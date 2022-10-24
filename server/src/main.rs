use axum::{handler::Handler, http::Uri, Extension, Router};
use sea_orm::{ConnectOptions, Database};
use tracing_subscriber::layer::SubscriberExt;

mod api;
mod entity;
mod error;
mod session;
mod user;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            std::env::var("RUST_LOG")
                .unwrap_or_else(|_| "blankpassword=debug,tower_http=debug".into()),
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();

    let mut opt =
        ConnectOptions::new(std::env::var("DATABASE_URL").expect("DATABASE_URL required"));
    opt.max_connections(10);

    let db = Database::connect(opt)
        .await
        .expect("cannot connect to database");

    let apiv1 = Router::new().nest(
        "/auth",
        Router::new()
            .route("/login", axum::routing::post(api::v1::auth::login))
            .route("/register", axum::routing::post(api::v1::auth::register))
            .route("/profile", axum::routing::get(api::v1::auth::profile)),
    );

    let app = Router::new()
        .nest("/api", Router::new().nest("/v1", apiv1))
        .fallback(handle_404.into_service())
        .layer(Extension(db));

    axum::Server::bind(&"0.0.0.0:3000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn handle_404(uri: Uri) -> error::Error {
    error::Error::NotFound(uri)
}
