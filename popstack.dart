/**
 * This file is part of the PopStack (Dart implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import "dart:convert";
import "dart:io";

HttpClient client = new HttpClient();

void fetch(String call, Function handler) {
    client.getUrl(Uri.parse("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow"))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
                response.transform(UTF8.decoder).transform(JSON.decoder).listen((dynamic data) {
                        handler(data);
                });
        });
}

String extractSnippet(String content) {
    //TODO
    return content;
}

void main() {
    fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany", (dynamic data) {
            for (dynamic item in data["items"]) {
                if (item.containsKey("accepted_answer_id")) {
                    fetch("answers/" + item["accepted_answer_id"].toString() + "?filter=withbody", (dynamic data) {
                            print(extractSnippet(data["items"][0]["body"]));
                    });

                    //TODO: first make sure there was a snippet extracted
                    return;
                }
            }

            //TODO: process more pages maybe?
    });
}
