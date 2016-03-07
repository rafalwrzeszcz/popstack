/**
 * This file is part of the PopStack (C++ implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#include <iostream>
#include <string>
#include <vector>

#include <boost/iostreams/copy.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/device/array.hpp>
#include <boost/iostreams/filter/gzip.hpp>

#include <cpprest/http_client.h>
#include <cpprest/http_msg.h>
#include <cpprest/json.h>
#include <pplx/pplxtasks.h>

using std::cout;
using std::endl;
using std::string;
using std::stringstream;
using std::vector;

using boost::iostreams::array_source;
using boost::iostreams::copy;
using boost::iostreams::filtering_istream;
using boost::iostreams::gzip_decompressor;

using pplx::task;
using web::http::methods;
using web::http::http_response;
using web::http::client::http_client;
using web::json::array;
using web::json::value;

int main() {
    //TODO: pick query from command line

    http_client client("http://api.stackexchange.com/2.2/similar?site=stackoverflow&order=desc&sort=relevance&title=Hibernate%20manytomany");
    client
        .request(methods::GET)
        .then([](http_response response) -> task< vector< unsigned char > > {
                return response.extract_vector();
        })
        .then([](vector< unsigned char > compressed) -> string {
                array_source input(reinterpret_cast< char* >(compressed.data()), compressed.size());

                filtering_istream filter;
                filter.push(gzip_decompressor());
                filter.push(input);

                stringstream output;

                copy(filter, output);

                return output.str();
        })
        .then([](string content) -> value {
                return value::parse(content);
        })
        .then([](value data) {
                array items = data.at("items").as_array();

                array::iterator iterator;
                for (iterator = items.begin(); iterator != items.end(); ++iterator) {
                    cout << *iterator << endl;
                }

                //TODO
        })
        .wait();

    return 0;
}
