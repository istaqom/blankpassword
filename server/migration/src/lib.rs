pub use sea_orm_migration::prelude::*;

mod m20221009_073302_create_user_table;
mod m20221009_175230_create_session_table;
mod m20221024_131801_create_credential_table;

pub struct Migrator;

#[async_trait::async_trait]
impl MigratorTrait for Migrator {
    fn migrations() -> Vec<Box<dyn MigrationTrait>> {
        vec![
            Box::new(m20221009_073302_create_user_table::Migration),
            Box::new(m20221009_175230_create_session_table::Migration),
            Box::new(m20221024_131801_create_credential_table::Migration),
        ]
    }
}
