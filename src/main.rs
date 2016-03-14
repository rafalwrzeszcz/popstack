/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate flate2;
extern crate hyper;

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

fn fetch(call: &str) -> String {
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

    return body;
}

fn main() {
    println!("{}", fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany"));
}
