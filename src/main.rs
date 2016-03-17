/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate core;
extern crate flate2;
extern crate hyper;
extern crate regex;
extern crate serde_json;
extern crate url;

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features (and investigate currently used ones)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects, especially HTTP client)
 */

use core::convert::From;

use std::env;
use std::io::{ Error as IoError, Read };

use flate2::read::GzDecoder;

use hyper::Client;
use hyper::error::Error as HyperError;

use regex::Regex;

use serde_json::{ Value, from_str };
use serde_json::error::Error as SerdeError;

use url::percent_encoding::{ DEFAULT_ENCODE_SET, utf8_percent_encode };

#[derive(Debug)]
enum AppError {
    Hyper(HyperError),
    Serde(SerdeError),
    Io(IoError)
}

impl From<HyperError> for AppError {
    fn from(error: HyperError) -> AppError {
        AppError::Hyper(error)
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

type AppResult<Type> = Result<Type, AppError>;

fn fetch(call: &str) -> AppResult<Value> {
    //TODO: make it reusable
    let client: Client = Client::new();

    //TODO: is there a better way?
    let mut url: String = "http://api.stackexchange.com/2.2/".to_owned();
    url.push_str(call);
    url.push_str("&site=stackoverflow");

    let response = try!(client.get(&url).send());
    let mut gzip = try!(GzDecoder::new(response));
    let mut body: String = String::new();
    try!(gzip.read_to_string(&mut body));
    from_str(&body).map_err(AppError::from)
}

fn extract_snippet(content: &str) -> Option<&str> {
    // this `.unwrap()` is safe as long as the regex is valid at compile time
    let snippet: Regex = Regex::new("(?s)<pre><code>(.*?)</code></pre>").unwrap();
    // this `.unwrap()` is safe as the regex match guarantees that there will be group 1
    snippet.captures(content).map(|group| group.at(1).unwrap().trim())
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();
    let mut query: String = "similar?order=desc&sort=relevance&title=".to_owned();
    query.push_str(&utf8_percent_encode(&args.join(" "), DEFAULT_ENCODE_SET));

    //TODO: handle unwraps
    let items: Value = fetch(&query).unwrap()
        .find("items").unwrap().to_owned();
    //TODO: handle unwrap
    for item in items.as_array().unwrap() {
        match item.find("accepted_answer_id") {
            Some(id) => {
                //TODO: is there a better way?
                let mut call: String = "answers/".to_owned();
                //TODO: handle unwrap
                call.push_str(&id.as_u64().unwrap().to_string());
                call.push_str("?filter=withbody");

                //TODO: any shorter way?
                //TODO: handle unwrap
                let answers: Value = fetch(&call).unwrap().find("items").unwrap().to_owned();
                //TODO: handle unwrap
                let ref answer: Value = answers.as_array().unwrap()[0];
                //TODO: handle unwraps
                println!("{}", extract_snippet(answer.find("body").unwrap().as_string().unwrap()).unwrap());

                //TODO: first make sure there was a snippet extracted
                break;
            },
            None => (),
        }
    }

    //TODO: process more pages maybe?

    //TODO: wrap everything into match result to print possible error
}
