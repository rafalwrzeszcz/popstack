/**
 * This file is part of the PopStack (C++ implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#include <iostream>
#include <string>
#include <vector>

#include <boost/algorithm/string/join.hpp>
#include <boost/iostreams/copy.hpp>
#include <boost/iostreams/device/array.hpp>
#include <boost/iostreams/filter/gzip.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/regex.hpp>

#include <cpprest/base_uri.h>
#include <cpprest/http_client.h>
#include <cpprest/http_msg.h>
#include <cpprest/json.h>
#include <pplx/pplxtasks.h>

using std::cout;
using std::endl;
using std::string;
using std::stringstream;
using std::vector;

using boost::algorithm::join;
using boost::iostreams::array_source;
using boost::iostreams::copy;
using boost::iostreams::filtering_istream;
using boost::iostreams::gzip_decompressor;
using boost::match_results;
using boost::regex;
using boost::regex_search;
using boost::smatch;

using pplx::task;
using web::http::methods;
using web::http::http_response;
using web::http::client::http_client;
using web::json::array;
using web::json::value;
using web::uri;

/* TODO
 * build tool
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features (like overloaded operators)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * "proper" HTTP client setup (headers, gzip as a middleware)
 */

const regex snippet("<pre><code>(.*?)</code></pre>");

task< value > fetch(const string call) {
    http_client client("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow");
    return client
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
        });
}

string extractSnippet(string body) {
    smatch match;
    if (regex_search(body, match, snippet)) {
        return match[1];
        //TODO: trim, unescape
    }

    return "";
}

int main(int argc, const char* argv[]) {
    vector< string > arguments(argv + 1, argv + argc);

    string body = fetch("similar?order=desc&sort=relevance&title=" + uri::encode_uri(join(arguments, " ")))
        .then([](value data) -> string {
                array items = data.at("items").as_array();

                array::iterator iterator;
                for (iterator = items.begin(); iterator != items.end(); ++iterator) {
                    if (iterator->has_field("accepted_answer_id")) {
                        return fetch("answers/" + iterator->at("accepted_answer_id").serialize() + "?filter=withbody")
                            .then([](value answer) -> string {
                                    return answer.at("items").at(0).at("body").as_string();
                            })
                            .then(&extractSnippet)
                            .get();
                        //TODO: first make sure there was a snippet extracted
                    }
                }

                //TODO; process more pages maybe?
                return "";
        })
        .get();

    cout << body << endl;

    return 0;
}
