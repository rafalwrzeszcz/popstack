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

type AppResult<Type> = Result<Type, AppError>;

fn fetch(call: &str) -> AppResult<Value> {
    //TODO: make it reusable - once provider abstraction is separated this can be done by struct property
    let client = Client::new();

    let mut url = "http://api.stackexchange.com/2.2/".to_owned();
    url.push_str(call);
    url.push_str("&site=stackoverflow");

    let response = try!(client.get(&url).send());
    let mut gzip = try!(GzDecoder::new(response));
    let mut body = String::new();
    try!(gzip.read_to_string(&mut body));
    from_str(&body).map_err(AppError::from)
}

fn extract_snippet(content: &str) -> Option<String> {
    // this `.unwrap()` is safe as long as the regex is valid at compile time
    let snippet = Regex::new("(?s)<pre><code>(.*?)</code></pre>").unwrap();
    // this `.unwrap()` is safe as the regex match guarantees that there will be group 1
    snippet.captures(content).map(|group| group.at(1).unwrap().trim().to_owned())
}

fn find_answer(id: u64) -> AppResult<Option<String>> {
    let mut call = "answers/".to_owned();
    call.push_str(&id.to_string());
    call.push_str("?filter=withbody");

    //TODO: it's a little messy, find out how to borrow needed values for required lifetime
    let root = try!(fetch(&call));
    match root
        .find("items")
        .and_then(|node| node.as_array())
    {
        Some(items) => {
            let ref answer = items[0].to_owned();

            Ok(
                answer
                    .find("body")
                    .and_then(|node| node.as_string())
                    .and_then(extract_snippet)
            )
        },
        None => Ok(None),
    }
}

//TODO: consider if we need Result<Option<>>, or maybe it's fine to use Result<String> and signal no result as Error
fn ask(query: &str) -> AppResult<Option<String>> {
    let mut url = "similar?order=desc&sort=relevance&title=".to_owned();
    url.push_str(query);

    let root = try!(fetch(&url));
    match root
        .find("items")
    {
        Some(&Value::Array(ref items)) => {
            //TODO: try to somehow flattern this
            for item in items {
                match item.find("accepted_answer_id") {
                    Some(&Value::U64(id)) => {
                        match try!(find_answer(id)) {
                            Some(snippet) => return Ok(Some(snippet)),
                            _ => (),
                        }
                    },
                    _ => (),
                }
            }
        },
        _ => (),
    }

    Ok(None)
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    match ask(&utf8_percent_encode(&args.join(" "), DEFAULT_ENCODE_SET)) {
        Ok(Some(snippet)) => println!("{}", snippet),
        //TODO: process more pages maybe?
        Ok(None) => println!("Your only help is http://google.com/ man!"),
        Err(error) => println!("Error occured: {:?}", error),
    }
}
