/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate flate2;
extern crate hyper;
extern crate regex;
extern crate serde_json;

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling (get rid of `unwrap()`s)
 * use more language features (and investigate currently used ones)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects, especially HTTP client)
 * "proper" HTTP client setup (headers, gzip as a middleware)
 */

use std::io::Read;

use flate2::read::GzDecoder;

use hyper::Client;
use hyper::client::Response;
use hyper::header::{AcceptEncoding, Encoding, qitem};

use regex::Regex;

use serde_json::{Value, from_str};

fn fetch(call: &str) -> Value {
    //TODO: make it reusable
    let client: Client = Client::new();

    //TODO: is there a better way?
    let mut url: String = "http://api.stackexchange.com/2.2/".to_owned();
    url.push_str(call);
    url.push_str("&site=stackoverflow");

    let response: Response = client.get(&url)
        .header(AcceptEncoding(vec![
                    qitem(Encoding::Gzip)
        ]))
        .send()
        .unwrap();

    let mut gzip: GzDecoder<Response> = GzDecoder::new(response).unwrap();

    let mut body: String = String::new();
    gzip.read_to_string(&mut body).unwrap();

    return from_str(&body).unwrap();
}

fn extract_snippet(content: &str) -> &str {
    let snippet: Regex = Regex::new("(?s)<pre><code>(.*?)</code></pre>").unwrap();
    match snippet.captures(content) {
        Some(group) => {
            return group.at(1).unwrap().trim();
            //TODO: unescape
        },
        None => return "",
    }
}

fn main() {
    //TODO: build query from command line arguments
    let items: Value = fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")
        .find("items").unwrap().to_owned();
    for item in items.as_array().unwrap() {
        match item.find("accepted_answer_id") {
            Some(id) => {
                //TODO: is there a better way?
                let mut call: String = "answers/".to_owned();
                call.push_str(&id.as_u64().unwrap().to_string());
                call.push_str("?filter=withbody");

                //TODO: any shorter way?
                let answers: Value = fetch(&call).find("items").unwrap().to_owned();
                let ref answer: Value = answers.as_array().unwrap()[0];
                println!("{}", extract_snippet(answer.find("body").unwrap().as_string().unwrap()));

                //TODO: first make sure there was a snippet extracted
                break;
            },
            None => (),
        }
    }

    //TODO: process more pages maybe?
}
