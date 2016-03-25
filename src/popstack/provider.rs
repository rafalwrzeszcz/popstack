/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

use super::error::AppResult;

pub trait Provider {
    fn search(&self, query: &str) -> AppResult<Option<String>>;
}
