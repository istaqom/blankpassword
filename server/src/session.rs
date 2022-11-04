use axum::{async_trait, extract::FromRequest};
use sea_orm::{prelude::Uuid, ActiveValue, DatabaseConnection, EntityTrait};

use crate::{
    entity::{self, session},
    error::Error,
};

pub async fn generate_session(
    db: &DatabaseConnection,
    uuid: Uuid,
) -> Result<String, sea_orm::DbErr> {
    use rand::Rng;

    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(255)
        .map(char::from)
        .collect();

    session::Entity::insert(session::ActiveModel {
        id: ActiveValue::Set(rand_string.clone()),
        user_id: ActiveValue::Set(uuid),
        payload: ActiveValue::Set(sea_orm::JsonValue::Object(Default::default())),
    })
    .exec(db)
    .await
    .map(|_| rand_string)
}

#[derive(Clone)]
pub struct Session {
    pub bearer: axum_auth::AuthBearer,
}

impl Session {
    pub async fn get_user_id(
        &self,
        db: &DatabaseConnection,
    ) -> Result<entity::session::Model, Error> {
        let it = entity::session::Entity::find_by_id(self.bearer.0.clone())
            .one(db)
            .await?;

        let it = match it {
            Some(it) => it,
            None => {
                return Err(Error::Unauthorized(
                    crate::error::UnauthorizedType::InvalidSessionId,
                ))
            }
        };

        Ok(it)
    }
}

#[async_trait]
impl<S> FromRequest<S> for Session
where
    S: Send,
{
    type Rejection = Error;

    async fn from_request(
        req: &mut axum::extract::RequestParts<S>,
    ) -> Result<Self, Self::Rejection> {
        let bearer = req
            .extract::<axum_auth::AuthBearer>()
            .await
            .map_err(|(code, err)| Error::CustomStatus(code, anyhow::anyhow!(err)))?;

        Ok(Session { bearer })
    }
}
