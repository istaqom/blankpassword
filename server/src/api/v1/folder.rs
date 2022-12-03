use axum::{extract::Path, Extension, Json};
use sea_orm::{
    prelude::Uuid,
    ActiveModelTrait,
    ActiveValue::{self, Set},
    ColumnTrait, DatabaseConnection, EntityTrait, PaginatorTrait, QueryFilter,
};
use serde::{Deserialize, Serialize};

use crate::{
    entity::folder,
    error::{Error, UnauthorizedType},
    user::UserUuid,
};

use super::{JsonFlattenSuccess, JsonSuccess};

#[derive(Serialize)]
pub struct IndexResponse {
    folders: Vec<Folder>,
}

#[derive(Serialize)]
pub struct Folder {
    id: Uuid,
    name: String,
}

pub async fn index(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
) -> Result<JsonFlattenSuccess<IndexResponse>, Error> {
    let folders = folder::Entity::find()
        .filter(folder::Column::UserId.eq(user_id))
        .all(&db)
        .await?
        .into_iter()
        .map(|it| Folder {
            id: it.id,
            name: it.name,
        })
        .collect();
    Ok(JsonFlattenSuccess(IndexResponse { folders }))
}

pub async fn check_own(db: &DatabaseConnection, user_id: Uuid, id: Uuid) -> Result<(), Error> {
    let model = folder::Entity::find_by_id(id)
        .filter(folder::Column::UserId.eq(user_id))
        .count(db)
        .await?;

    if model > 0 {
        Ok(())
    } else {
        Err(Error::Unauthorized(UnauthorizedType::NoPermission))
    }
}

#[derive(Deserialize, Clone, Debug)]
pub struct FolderRequest {
    name: String,
}

impl FolderRequest {
    fn into_active_model(
        self,
        id: ActiveValue<Uuid>,
        user_id: ActiveValue<Uuid>,
    ) -> folder::ActiveModel {
        folder::ActiveModel {
            id,
            user_id,
            name: Set(self.name),
        }
    }
}

#[derive(Serialize, Debug)]
pub struct FolderResponse {
    id: Uuid,
}

pub async fn store(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Json(request): Json<FolderRequest>,
) -> Result<JsonSuccess<FolderResponse>, Error> {
    let id = Uuid::new_v4();

    folder::Entity::insert(request.into_active_model(Set(id), Set(user_id)))
        .exec(&db)
        .await?;

    Ok(JsonSuccess(FolderResponse { id }))
}

pub async fn update(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Path(id): Path<Uuid>,
    Json(request): Json<FolderRequest>,
) -> Result<JsonSuccess<()>, Error> {
    check_own(&db, user_id, id).await?;

    request
        .into_active_model(Set(id), ActiveValue::NotSet)
        .update(&db)
        .await?;

    Ok(JsonSuccess(()))
}

pub async fn delete(
    Extension(db): Extension<DatabaseConnection>,
    UserUuid(user_id): UserUuid,
    Path(id): Path<Uuid>,
) -> Result<(), Error> {
    check_own(&db, user_id, id).await?;
    folder::Entity::delete_by_id(id).exec(&db).await?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use axum::{extract::Path, Json};

    use crate::api::v1::tests::bootstrap;

    use super::FolderRequest;

    #[tokio::test]
    async fn test() {
        let bootstrap = bootstrap().await;

        let data = FolderRequest {
            name: "test".to_string(),
        };

        let store_response = super::store(bootstrap.db(), bootstrap.uuid(), Json(data.clone()))
            .await
            .unwrap()
            .0;

        let get_data = || async {
            super::index(bootstrap.db(), bootstrap.uuid())
                .await
                .map(|it| it.0)
        };

        let response = get_data().await.unwrap();
        assert_eq!(response.folders.len(), 1);
        assert_eq!(response.folders[0].name, data.name);
        assert_eq!(response.folders[0].id, store_response.id);

        let data = FolderRequest {
            name: "tset".to_string(),
        };

        super::update(
            bootstrap.db(),
            bootstrap.uuid(),
            Path(store_response.id),
            Json(data.clone()),
        )
        .await
        .unwrap();

        let response = get_data().await.unwrap();
        assert_eq!(response.folders.len(), 1);
        assert_eq!(response.folders[0].name, data.name);
        assert_eq!(response.folders[0].id, store_response.id);

        let other_user = bootstrap.derive("example2@example.com", "password").await;
        super::update(
            other_user.db(),
            other_user.uuid(),
            Path(store_response.id),
            Json(data.clone()),
        )
        .await
        .expect_err("different user");

        super::delete(
            other_user.db(),
            other_user.uuid(),
            Path(store_response.id),
        )
        .await
        .expect_err("different user");

        let response = get_data().await.unwrap();
        assert_eq!(response.folders.len(), 1);

        super::delete(bootstrap.db(), bootstrap.uuid(), Path(store_response.id))
            .await
            .unwrap();

        let response = super::index(bootstrap.db(), bootstrap.uuid())
            .await
            .unwrap()
            .0;

        assert_eq!(response.folders.len(), 0);
    }
}
