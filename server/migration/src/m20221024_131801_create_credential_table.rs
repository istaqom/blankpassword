use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(Credential::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(Credential::Id)
                            .uuid()
                            .not_null()
                            .primary_key(),
                    )
                    .col(ColumnDef::new(Credential::Name).string().not_null())
                    .col(ColumnDef::new(Credential::Data).json().not_null())
                    .col(ColumnDef::new(Credential::UserId).uuid().not_null())
                    .foreign_key(
                        ForeignKey::create()
                            .name("fk_credential_user_id")
                            .from(Credential::Table, Credential::UserId)
                            .to(User::Table, User::Id),
                    )
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(Credential::Table).to_owned())
            .await
    }
}

/// Learn more at https://docs.rs/sea-query#iden
#[derive(Iden)]
enum Credential {
    Table,
    Id,
    UserId,
    Name,
    Data,
}

#[derive(Iden)]
enum User {
    Table,
    Id,
}
