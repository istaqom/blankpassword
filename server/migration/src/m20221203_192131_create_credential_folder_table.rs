use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(CredentialFolder::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(CredentialFolder::Id)
                            .integer()
                            .not_null()
                            .auto_increment()
                            .primary_key(),
                    )
                    .col(ColumnDef::new(CredentialFolder::FolderId).uuid().not_null())
                    .col(
                        ColumnDef::new(CredentialFolder::CredentialId)
                            .uuid()
                            .not_null(),
                    )
                    .foreign_key(
                        ForeignKey::create()
                            .name("fk_credential_id")
                            .from(CredentialFolder::Table, CredentialFolder::CredentialId)
                            .to(Credential::Table, Credential::Id),
                    )
                    .foreign_key(
                        ForeignKey::create()
                            .name("fk_folder_id")
                            .from(CredentialFolder::Table, CredentialFolder::FolderId)
                            .to(Folder::Table, Folder::Id),
                    )
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(CredentialFolder::Table).to_owned())
            .await
    }
}

/// Learn more at https://docs.rs/sea-query#iden
#[derive(Iden)]
enum CredentialFolder {
    Table,
    Id,
    CredentialId,
    FolderId,
}

#[derive(Iden)]
enum Credential {
    Table,
    Id,
}

#[derive(Iden)]
enum Folder {
    Table,
    Id,
}
