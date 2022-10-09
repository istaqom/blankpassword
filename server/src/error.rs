use axum::{
    http::{StatusCode, Uri},
    response::IntoResponse,
    Json,
};
use serde::{Deserialize, Serialize};

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("validation error: {0}")]
    ValidationError(#[from] validator::ValidationErrors),

    #[error("{0} not found")]
    NotFound(Uri),
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ErrorJson {
    #[serde(skip_serializing_if = "Option::is_none")]
    errors: Option<serde_json::Value>,
    r#type: String,
    message: String,
}

impl From<Error> for ErrorJson {
    fn from(err: Error) -> Self {
        let message = err.to_string();

        let r#type = err.to_string_variant();

        let errors = match err {
            Error::ValidationError(err) => serde_json::to_value(err).ok(),
            Error::NotFound(..) => None,
        };

        Self {
            errors,
            message,
            r#type,
        }
    }
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        let status = match self {
            Self::ValidationError(..) => StatusCode::BAD_REQUEST,
            Self::NotFound(..) => StatusCode::NOT_FOUND,
        };

        let error = ErrorJson::from(self);

        (status, Json(error)).into_response()
    }
}

impl Error {
    pub fn to_string_variant(&self) -> String {
        macro_rules! match_var {
            ($id:ident (..)) => {
                Self::$id(..)
            };
            ($id:ident {..}) => {
                Self::$id { .. }
            };
        }

        macro_rules! variant {
            ($($name:ident $tt:tt),+) => {
                match self {
                  $(match_var!($name $tt) => {
                    stringify!($name)
                  }),+
                }
          };
        }

        variant! {
            NotFound(..),
            ValidationError(..)
        }
        .to_string()
    }
}

