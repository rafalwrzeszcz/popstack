/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate core;
extern crate hyper;
extern crate serde_json;

use self::core::convert::From;

use self::hyper::error::Error as HyperError;

use self::serde_json::error::Error as SerdeError;

use std::io::Error as IoError;

#[derive(Debug)]
pub enum AppError {
    Hyper(HyperError),
    Serde(SerdeError),
    Io(IoError),
    Http(String)
}

impl From<HyperError> for AppError {
    fn from(error: HyperError) -> AppError {
        match error {
            HyperError::Io(error) => AppError::Io(error),
            _ => AppError::Hyper(error),
        }
    }
}

impl From<SerdeError> for AppError {
    fn from(error: SerdeError) -> AppError {
        AppError::Serde(error)
    }
}

impl From<IoError> for AppError {
    fn from(error: IoError) -> AppError {
        AppError::Io(error)
    }
}

pub type AppResult<Type> = Result<Type, AppError>;
