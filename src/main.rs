/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate core;
extern crate url;

mod popstack;

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

use std::env::args;

use popstack::provider::Provider;
use popstack::stackoverflow::StackOverflowProvider;

use url::percent_encoding::{ DEFAULT_ENCODE_SET, utf8_percent_encode };

fn main() {
    let args: Vec<String> = args().skip(1).collect();
    let provider = StackOverflowProvider::new();

    match provider.search(&utf8_percent_encode(&args.join(" "), DEFAULT_ENCODE_SET)) {
        Ok(Some(snippet)) => println!("{}", snippet),
        Ok(None) => println!("Your only help is http://google.com/ man!"),
        Err(error) => println!("Error occured: {:?}", error),
    }
}
