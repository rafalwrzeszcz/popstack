/**
 * This file is part of the PopStack (Dart implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import "dart:convert";
import "dart:io";

/* TODO:
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * why program hangs after finishing request - probably HTTP client needs to be closed
 */

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

RegExp snippet = new RegExp("<pre><code>([\\s\\S]*?)</code></pre>");

String extractSnippet(String content) {
    Match match = snippet.firstMatch(content);
    if (match != null) {
        return match.group(1).trim();
        //TODO: unescape
    }

    return "";
}

void main(List<String> args) {
    String query = args.join(" ");

    fetch("similar?order=desc&sort=relevance&title=" + Uri.encodeQueryComponent(query), (dynamic data) {
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
