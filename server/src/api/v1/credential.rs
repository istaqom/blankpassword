use axum::{extract::Path, Extension, Json};
use sea_orm::{
    prelude::Uuid, ActiveModelTrait, ActiveValue, ColumnTrait, DatabaseConnection, EntityTrait,
    PaginatorTrait, QueryFilter, QuerySelect, RelationTrait,
};
use serde::{Deserialize, Serialize};

use crate::{
    entity::{credential, credential_folder, folder},
    error::{Error, UnauthorizedType},
    user::UserUuid,
};

use super::{JsonFlattenSuccess, JsonSuccess};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct CredentialRequest {
    name: String,
    data: serde_json::Value,
    folders: Vec<FolderRequest>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct FolderRequest {
    id: Uuid,
}

impl CredentialRequest {
    pub fn into_active_model(
        &self,
        id: ActiveValue<Uuid>,
        user_id: ActiveValue<Uuid>,
    ) -> credential::ActiveModel {
        credential::ActiveModel {
            id,
            user_id,
            name: ActiveValue::Set(self.name.clone()),
            data: ActiveValue::Set(self.data.clone()),
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CredentialResponse {
    id: Uuid,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Credential {
    id: Uuid,
    name: String,
    data: serde_json::Value,
    folders: Vec<Folder>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Folder {
    id: Uuid,
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
    let id = Uuid::new_v4();

    credential::Entity::insert(
        request.into_active_model(ActiveValue::Set(id), ActiveValue::Set(user_id)),
    )
    .exec(&db)
    .await?;
    insert_folder(&db, id, request.folders).await?;

    Ok(JsonSuccess(CredentialResponse { id }))
}

pub async fn index(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
) -> Result<JsonFlattenSuccess<IndexResponse>, Error> {
    let credentials = credential::Entity::find()
        .find_with_related(credential_folder::Entity)
        .filter(credential::Column::UserId.eq(user_id))
        .all(&db)
        .await?
        .into_iter()
        .map(|(it, folder)| Credential {
            id: it.id,
            name: it.name,
            data: it.data,
            folders: folder
                .into_iter()
                .map(|it| Folder { id: it.folder_id })
                .collect(),
        })
        .collect();

    Ok(JsonFlattenSuccess(IndexResponse { data: credentials }))
}

pub async fn check_own(db: &DatabaseConnection, user_id: Uuid, id: Uuid) -> Result<(), Error> {
    let model = credential::Entity::find_by_id(id)
        .filter(credential::Column::UserId.eq(user_id))
        .count(db)
        .await?;

    if model > 0 {
        Ok(())
    } else {
        Err(Error::Unauthorized(UnauthorizedType::NoPermission))
    }
}

pub async fn insert_folder(
    db: &DatabaseConnection,
    id: Uuid,
    folders: Vec<FolderRequest>,
) -> Result<(), migration::DbErr> {
    if !folders.is_empty() {
        credential_folder::Entity::insert_many(folders.iter().map(|it| {
            credential_folder::ActiveModel {
                id: ActiveValue::NotSet,
                folder_id: ActiveValue::Set(it.id),
                credential_id: ActiveValue::Set(id),
            }
        }))
        .exec(db)
        .await
        .map(|_| ())
    } else {
        Ok(())
    }
}

pub async fn delete_folder(
    db: &DatabaseConnection,
    id: Uuid,
) -> Result<sea_orm::DeleteResult, migration::DbErr> {
    credential_folder::Entity::delete_many()
        .filter(credential_folder::Column::CredentialId.eq(id))
        .exec(db)
        .await
}

pub async fn delete(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Path(id): Path<Uuid>,
) -> Result<JsonSuccess<()>, Error> {
    check_own(&db, user_id, id).await?;
    delete_folder(&db, id).await?;
    credential::Entity::delete_by_id(id).exec(&db).await?;
    Ok(JsonSuccess(()))
}

pub async fn update(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Path(id): Path<Uuid>,
    Json(request): Json<CredentialRequest>,
) -> Result<JsonSuccess<()>, Error> {
    check_own(&db, user_id, id).await?;
    request
        .into_active_model(ActiveValue::Set(id), ActiveValue::NotSet)
        .update(&db)
        .await?;
    delete_folder(&db, id).await?;

    insert_folder(&db, id, request.folders).await?;

    Ok(JsonSuccess(()))
}

#[cfg(test)]
mod tests {

    use crate::api::v1::{tests::Bootstrap, JsonFlattenSuccess};

    use axum::{extract::Path, Json};

    #[tokio::test]
    async fn test() {
        let bootstrap = super::super::tests::bootstrap().await;

        let data = super::CredentialRequest {
            name: "yiha".to_string(),
            data: serde_json::json!({
                "user": "email",
                "password": "password",
            }),
            folders: vec![],
        };

        super::store(bootstrap.db(), bootstrap.uuid(), Json(data.clone()))
            .await
            .unwrap();

        let other_user = bootstrap.derive("example2@example.com", "password").await;

        let get_data = |a: &Bootstrap| super::index(a.db(), a.uuid());
        let get_data_bootstrap = || get_data(&bootstrap);

        let JsonFlattenSuccess(response) = get_data_bootstrap().await.unwrap();
        assert_eq!(response.data.len(), 1);
        assert_eq!(response.data[0].name, data.name);
        assert_eq!(response.data[0].data, data.data);

        let data = super::CredentialRequest {
            name: "hayi".to_string(),
            data: serde_json::json!({
                "email": "user",
                "password": "password"
            }),
            folders: vec![],
        };

        super::update(
            bootstrap.db(),
            bootstrap.uuid(),
            Path(response.data[0].id),
            Json(data.clone()),
        )
        .await
        .unwrap();

        let JsonFlattenSuccess(response) = get_data_bootstrap().await.unwrap();
        assert_eq!(response.data.len(), 1);
        assert_eq!(response.data[0].name, data.name);
        assert_eq!(response.data[0].data, data.data);

        super::update(
            other_user.db(),
            other_user.uuid(),
            Path(response.data[0].id),
            Json(data.clone()),
        )
        .await
        .expect_err("different user");

        super::delete(
            other_user.db(),
            other_user.uuid(),
            Path(response.data[0].id),
        )
        .await
        .expect_err("different user");
        let JsonFlattenSuccess(response) = get_data_bootstrap().await.unwrap();
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
