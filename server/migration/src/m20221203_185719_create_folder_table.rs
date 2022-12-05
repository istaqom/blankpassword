use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(Folder::Table)
                    .if_not_exists()
                    .col(ColumnDef::new(Folder::Id).uuid().primary_key())
                    .col(ColumnDef::new(Folder::UserId).uuid().not_null())
                    .col(ColumnDef::new(Folder::Name).string().not_null())
                    .foreign_key(
                        ForeignKey::create()
                            .from(Folder::Table, Folder::UserId)
                            .to(User::Table, User::Id),
                    )
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(Folder::Table).to_owned())
            .await
    }
}

#[derive(Iden)]
enum Folder {
    Table,
    Id,
    UserId,
    Name,
}

#[derive(Iden)]
enum User {
    Table,
    Id,
}
