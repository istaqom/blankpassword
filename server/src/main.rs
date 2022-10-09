use axum::{handler::Handler, http::Uri, Router};

mod error;
#[tokio::main]
async fn main() {
    let app = Router::new();
    let app = Router::new()
        .fallback(handle_404.into_service());
    let app = Router::new().fallback(handle_404.into_service());

    axum::Server::bind(&"0.0.0.0:3000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn handle_404(uri: Uri) -> error::Error {
    error::Error::NotFound(uri)
}
