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

    #[error("{0}")]
    PasswordHashError(#[from] password_hash::Error),

    #[error("{0}")]
    DatabaseError(#[from] sea_orm::DbErr),

    #[error("{0} must unique")]
    MustUniqueError(String),

    #[error("{0}")]
    Unauthorized(UnauthorizedType),

    #[error("{1}")]
    CustomStatus(StatusCode, anyhow::Error)
}

#[derive(Debug, thiserror::Error)]
pub enum UnauthorizedType {
    #[error("Wrong Username or Password")]
    WrongUsernameOrPassword,

    #[error("Invalid session id")]
    InvalidSessionId
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
            Error::NotFound(..)
            | Error::PasswordHashError(..)
            | Error::DatabaseError(..)
            | Error::MustUniqueError(..)
            | Error::Unauthorized(..) | Error::CustomStatus(..)=> None,
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
            Self::Unauthorized(..) => StatusCode::UNAUTHORIZED,
            Self::ValidationError(..) | Self::MustUniqueError(..) => {
                StatusCode::UNPROCESSABLE_ENTITY
            }
            Self::NotFound(..) => StatusCode::NOT_FOUND,
            Self::PasswordHashError(..) | Self::DatabaseError(..) => {
                StatusCode::INTERNAL_SERVER_ERROR
            }
            Self::CustomStatus(code, ..) => code,
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
            ValidationError(..),
            PasswordHashError(..),
            DatabaseError(..),
            MustUniqueError(..),
            Unauthorized(..),
            CustomStatus(..)
        }
        .to_string()
    }
}
