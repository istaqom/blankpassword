use axum::{async_trait, extract::FromRequest, Extension};
use sea_orm::{prelude::Uuid, DatabaseConnection, EntityTrait};
use serde::{Deserialize, Serialize};

use crate::{
    entity,
    error::{Error, UnauthorizedType},
    session::Session,
};

#[derive(Debug, Serialize, Deserialize)]
pub struct User {
    pub id: Uuid,
    pub email: String,
}

#[async_trait]
impl<B> FromRequest<B> for User
where
    B: Send,
{
    type Rejection = Error;

    async fn from_request(
        req: &mut axum::extract::RequestParts<B>,
    ) -> Result<Self, Self::Rejection> {
        let Extension(db) = req
            .extract::<Extension<DatabaseConnection>>()
            .await
            .unwrap();

        let session = req.extract::<Session>().await?;
        Self::from_session(&db, session).await
    }
}

impl User {
    pub async fn from_session(db: &DatabaseConnection, session: Session) -> Result<Self, Error> {
        let session = session.get_user_id(&db).await?;

        let user = entity::user::Entity::find_by_id(session.user_id)
            .one(db)
            .await?;

        let user = match user {
            Some(user) => user,
            None => return Err(Error::Unauthorized(UnauthorizedType::InvalidSessionId)),
        };

        Ok(User {
            id: user.id,
            email: user.email,
        })
    }
}
