/**
 * This file is part of the PopStack (Ceylon implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features (like overloaded operators)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * try to use standard HTTP client instead of Vert.x (we can't upgrade to 1.2.1, but HTTP client breaks on GZip)
 */

import ceylon.json { Object, Value }

import ceylon.regex { regex, MatchResult, Regex }

import io.vertx.ceylon.core { vertx, Vertx }
import io.vertx.ceylon.core.buffer { Buffer }
import io.vertx.ceylon.core.http { HttpClient, HttpClientOptions, HttpClientRequest, HttpClientResponse }

Vertx context = vertx.vertx();
HttpClient client = context.createHttpClient(HttpClientOptions {
        defaultHost = "api.stackexchange.com";
        tryUseCompression = true;
});

void fetch(String call, Callable<Anything,[Object]> callback) {
    HttpClientRequest request = client.get("/2.2/" + call + "&site=stackoverflow", (HttpClientResponse response) {
            response.bodyHandler((Buffer totalBuffer) {
                    callback(totalBuffer.toJsonObject());
            });
    });
    request.end();
}

Regex snippet = regex("(?s)<pre><code>(.*?)</code></pre>");

String extractSnippet(String content) {
    MatchResult? match = snippet.find(content);
    if (exists match) {
        String? code = match.groups[0];
        if (exists code) {
            return code.trimmed;
            //TODO: unescape
        }
    }

    return "";
}

shared void run() {
    //TODO: build query from cmd line

    fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany", (Object data) {
            for (Value item in data.getArray("items")) {
                if (is Object item) {
                    if (item.defines("accepted_answer_id")) {
                        fetch("answers/" + item.getInteger("accepted_answer_id").string + "?filter=withbody", (Object data) {
                                Value answer = data.getArray("items").get(0);
                                if (is Object answer) {
                                    print(extractSnippet(answer.getString("body")));
                                }
                        });

                        //TODO: first make sure there was a snippet extracted
                        break;
                    }
                }
            }
    });

    //TODO; process more pages maybe?
    //TODO: why app doesn't end after displaying?
}
