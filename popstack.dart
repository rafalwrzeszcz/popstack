/**
 * This file is part of the PopStack (Dart implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import "dart:convert";
import "dart:io";

HttpClient client = new HttpClient();

void fetch(String call) {
    client.getUrl(Uri.parse("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow"))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
                response.transform(UTF8.decoder).transform(JSON.decoder).listen((dynamic data) {
                        print(data);
                        //TODO
                });
        });
}

void main() {
    fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany");
}
