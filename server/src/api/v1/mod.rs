pub mod auth;
pub mod credential;

#[cfg(test)]
mod tests {
    use axum::{Extension, Json};
    use migration::MigratorTrait;
    use sea_orm::{Database, DatabaseConnection};

    use crate::user::{User, UserUuid};

    pub struct Bootstrap {
        user: User,
        connection: DatabaseConnection,
    }

    impl Bootstrap {
        pub fn db(&self) -> Extension<DatabaseConnection> {
            Extension(self.connection.clone())
        }

        pub fn uuid(&self) -> UserUuid {
            UserUuid(self.user.id)
        }

        pub async fn derive(&self, email: &str, password: &str) -> Bootstrap {
            let user = create_user(&self.connection, email, password).await;

            Bootstrap {
                user,
                connection: self.connection.clone(),
            }
        }
    }

    pub async fn connection() -> DatabaseConnection {
        let db = Database::connect("sqlite::memory:").await.unwrap();
        migration::Migrator::up(&db, None).await.unwrap();
        db
    }

    pub async fn create_user(db: &DatabaseConnection, email: &str, password: &str) -> User {
        let Json(user) = super::auth::register(
            Extension(db.clone()),
            Json(super::auth::AuthRequest {
                email: email.to_string(),
                password: password.to_string(),
            }),
        )
        .await
        .unwrap();

        crate::user::User::from_session(
            db,
            crate::session::Session {
                bearer: axum_auth::AuthBearer(user.session),
            },
        )
        .await
        .unwrap()
    }

    pub async fn bootstrap() -> Bootstrap {
        let db = connection().await;
        let user = create_user(&db, "example@example.com", "password").await;

        Bootstrap {
            connection: db,
            user,
        }
    }
}
