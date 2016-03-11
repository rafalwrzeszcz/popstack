/**
 * This file is part of the PopStack (Ceylon implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import ceylon.json { Object, Value }

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

String extractSnippet(String content) {
    return content;
}

shared void run() {
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
                        break;
                    }
                }
            }
    });
}
