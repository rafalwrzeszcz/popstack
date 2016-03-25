/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate flate2;
extern crate hyper;
extern crate marksman_escape;
extern crate regex;
extern crate serde_json;
extern crate url;

use super::error::{ AppError, AppResult };
use super::provider::Provider;

use std::io::Read;

use self::flate2::read::GzDecoder;

use self::hyper::Client;

use self::marksman_escape::Unescape;

use self::regex::Regex;

use self::serde_json::{ Value, from_str };

use self::url::percent_encoding::{ DEFAULT_ENCODE_SET, utf8_percent_encode };

pub struct StackOverflowProvider {
    client: Client
}

impl StackOverflowProvider {
    pub fn new() -> StackOverflowProvider {
        StackOverflowProvider { client: Client::new() }
    }

    fn fetch(&self, call: &str) -> AppResult<Value> {
        let mut url = "http://api.stackexchange.com/2.2/".to_owned();
        url.push_str(call);
        url.push_str("&site=stackoverflow");

        let response = try!(self.client.get(&url).send());
        let mut gzip = try!(GzDecoder::new(response));
        let mut body = String::new();
        try!(gzip.read_to_string(&mut body));
        from_str(&body)
            .map_err(AppError::from)
            .and_then(|ref root: Value| match root.find("error_message") {
                    Some(&Value::String(ref message)) => Err(AppError::Http(message.to_owned())),
                    _ => Ok(root.to_owned()),
            })
    }

    fn find_answer(&self, id: u64) -> AppResult<Option<String>> {
        let mut call = "answers/".to_owned();
        call.push_str(&id.to_string());
        call.push_str("?filter=withbody");

        Ok(
            try!(self.fetch(&call))
                .find("items")
                .and_then(|node| node.as_array())
                .map(|items| items[0].to_owned())
                //TODO: it's a little messy, find out how to borrow needed values for required lifetime
                .and_then(|item|
                        item.find("body")
                            .and_then(|node| node.as_string())
                            .and_then(extract_snippet)
                )
        )
    }
}

fn extract_snippet(content: &str) -> Option<String> {
    // this `.unwrap()` is safe as long as the regex is valid at compile time
    let snippet = Regex::new("(?s)<pre><code>(.*?)</code></pre>").unwrap();
    snippet.captures(content)
        // this `.unwrap()` is safe as the regex match guarantees that there will be group 1
        .map(|group| group.at(1).unwrap().trim().to_owned())
        .and_then(|string| String::from_utf8(Unescape::new(string.bytes()).collect()).ok())
}

impl Provider for StackOverflowProvider {
    fn search(&self, query: &str) -> AppResult<Option<String>> {
        let mut url = "similar?order=desc&sort=relevance&title=".to_owned();
        url.push_str(&utf8_percent_encode(query, DEFAULT_ENCODE_SET));

        match try!(self.fetch(&url))
            .find("items")
        {
            Some(&Value::Array(ref items)) => {
                //TODO: try to somehow flattern this
                for item in items {
                    match item.find("accepted_answer_id") {
                        Some(&Value::U64(id)) => {
                            match try!(self.find_answer(id)) {
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

        //TODO: process more pages maybe?
        Ok(None)
    }
}
