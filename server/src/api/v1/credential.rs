use axum::{extract::Path, Extension, Json};
use sea_orm::{
    prelude::Uuid, ActiveValue, ColumnTrait, DatabaseConnection, EntityTrait, PaginatorTrait,
    QueryFilter,
};
use serde::{Deserialize, Serialize};

use crate::{
    entity::credential,
    error::{Error, UnauthorizedType},
    user::UserUuid,
};

use super::{JsonFlattenSuccess, JsonSuccess};

#[derive(Serialize, Deserialize, Debug)]
pub struct CredentialRequest {
    name: String,
    data: serde_json::Value,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CredentialResponse {
    uuid: Uuid,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Credential {
    id: Uuid,
    name: String,
    data: serde_json::Value,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct IndexResponse {
    data: Vec<Credential>,
}

pub async fn store(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Json(request): Json<CredentialRequest>,
) -> Result<JsonSuccess<CredentialResponse>, Error> {
    let uuid = Uuid::new_v4();

    credential::Entity::insert(credential::ActiveModel {
        id: ActiveValue::Set(uuid),
        user_id: ActiveValue::Set(user_id),
        name: ActiveValue::Set(request.name),
        data: ActiveValue::Set(request.data),
    })
    .exec(&db)
    .await?;

    Ok(JsonSuccess(CredentialResponse { uuid }))
}

pub async fn index(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
) -> Result<JsonFlattenSuccess<IndexResponse>, Error> {
    let credentials = credential::Entity::find()
        .filter(credential::Column::UserId.eq(user_id))
        .all(&db)
        .await?
        .into_iter()
        .map(|it| Credential {
            id: it.id,
            name: it.name,
            data: it.data,
        })
        .collect();

    Ok(JsonFlattenSuccess(IndexResponse { data: credentials }))
}

pub async fn delete(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Path(id): Path<Uuid>,
) -> Result<JsonSuccess<()>, Error> {
    let model = credential::Entity::find_by_id(id)
        .filter(credential::Column::UserId.eq(user_id))
        .count(&db)
        .await?;

    if model > 0 {
        credential::Entity::delete_by_id(id).exec(&db).await?;
        Ok(JsonSuccess(()))
    } else {
        Err(Error::Unauthorized(UnauthorizedType::NoPermission))
    }
}

#[cfg(test)]
mod tests {

    use crate::api::v1::JsonFlattenSuccess;

    use axum::{extract::Path, Json};

    #[tokio::test]
    async fn test() {
        let bootstrap = super::super::tests::bootstrap().await;

        super::store(
            bootstrap.db(),
            bootstrap.uuid(),
            Json(super::CredentialRequest {
                name: "yiha".to_string(),
                data: serde_json::json!({
                    "user": "email",
                    "password": "password",
                }),
            }),
        )
        .await
        .unwrap();

        let other_user = bootstrap.derive("example2@example.com", "password").await;

        let get_data = || super::index(bootstrap.db(), bootstrap.uuid());

        let JsonFlattenSuccess(response) = get_data().await.unwrap();
        assert_eq!(response.data.len(), 1);

        super::delete(
            other_user.db(),
            other_user.uuid(),
            Path(response.data[0].id),
        )
        .await
        .expect_err("different user");
        let JsonFlattenSuccess(response) = get_data().await.unwrap();
        assert_eq!(response.data.len(), 1);

        super::delete(bootstrap.db(), bootstrap.uuid(), Path(response.data[0].id))
            .await
            .unwrap();

        let JsonFlattenSuccess(response) = super::index(bootstrap.db(), bootstrap.uuid())
            .await
            .unwrap();
        assert_eq!(response.data.len(), 0);
    }
}