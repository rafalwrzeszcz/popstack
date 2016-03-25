/**
 * This file is part of the PopStack (Rust implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

extern crate core;

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

fn main() {
    let args: Vec<String> = args().skip(1).collect();
    let provider = StackOverflowProvider::new();

    match provider.search(&args.join(" ")) {
        Ok(Some(snippet)) => println!("{}", snippet),
        Ok(None) => println!("Your only help is http://google.com/ man!"),
        Err(error) => println!("Error occured: {:?}", error),
    }
}
