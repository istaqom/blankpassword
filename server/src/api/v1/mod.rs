pub mod auth;
pub mod credential;

#[cfg(test)]
mod tests {
    use axum::{Extension, Json};
    use migration::MigratorTrait;
    use sea_orm::{Database, DatabaseConnection};

    use crate::{session::Session, user::UserUuid};

    #[allow(dead_code)]
    pub struct Bootstrap {
        user_model: crate::entity::user::Model,
        user_password: String,
        session: Session,
        pub connection: DatabaseConnection,
    }

    impl Bootstrap {
        pub fn db(&self) -> Extension<DatabaseConnection> {
            Extension(self.connection.clone())
        }

        pub fn uuid(&self) -> UserUuid {
            UserUuid(self.user_model.id)
        }

        pub async fn user_model(&self) -> crate::entity::user::Model {
            self.user_model.clone()
        }

        pub fn user_email(&self) -> String {
            self.user_model.email.clone()
        }

        pub fn user_password(&self) -> String {
            self.user_password.clone()
        }

        pub async fn derive(&self, email: &str, password: &str) -> Bootstrap {
            let (user, session) = create_user(&self.connection, email, password).await;

            Bootstrap {
                user_model: user,
                user_password: password.to_string(),
                session,
                connection: self.connection.clone(),
            }
        }
    }

    pub async fn connection() -> DatabaseConnection {
        let db = Database::connect("sqlite::memory:").await.unwrap();
        migration::Migrator::up(&db, None).await.unwrap();
        db
    }

    pub async fn create_user(
        db: &DatabaseConnection,
        email: &str,
        password: &str,
    ) -> (crate::entity::user::Model, Session) {
        let Json(user) = super::auth::register(
            Extension(db.clone()),
            Json(super::auth::AuthRequest {
                email: email.to_string(),
                password: password.to_string(),
            }),
        )
        .await
        .unwrap();

        let session = crate::session::Session {
            bearer: axum_auth::AuthBearer(user.session),
        };

        let user = crate::entity::user::Model::from_session(db, session.clone())
            .await
            .unwrap();

        (user, session)
    }

    pub async fn bootstrap() -> Bootstrap {
        let db = connection().await;
        let password = "password";
        let (user, session) = create_user(&db, "example@example.com", password).await;

        Bootstrap {
            connection: db,
            user_model: user,
            user_password: password.to_string(),
            session,
        }
    }
}
