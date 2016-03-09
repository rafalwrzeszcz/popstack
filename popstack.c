/**
 * This file is part of the PopStack (C implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <curl/curl.h>

#include <glib.h>

#include <jansson.h>

#define BUFFER_SIZE (256 * 1024) /* 256 KB */

/*TODO:
 * proper handling of memory allocation/freeing
 * build tool
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * error handling
 * use more language features (like overloaded operators)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * "proper" HTTP client setup (headers)
 */

typedef struct {
    char* data;
    int pos;
} write_result;

static size_t write_response(void* ptr, size_t size, size_t nmemb, void* stream) {
    write_result* result = (write_result*) stream;

    memcpy(result->data + result->pos, ptr, size * nmemb);
    result->pos += size * nmemb;

    return size * nmemb;
}

static char* request(const char* call) {
    CURL* curl = NULL;
    char* data = NULL;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();

    data = malloc(BUFFER_SIZE);

    write_result write_result = {
        .data = data,
        .pos = 0
    };

    char* url = g_strconcat("http://api.stackexchange.com/2.2/", call, "&site=stackoverflow", NULL);

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_response);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &write_result);
    curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, "gzip");

    curl_easy_perform(curl);

    curl_easy_cleanup(curl);
    curl_global_cleanup();

    g_free(url);

    /* zero-terminate the result */
    data[write_result.pos] = '\0';

    return data;
}

char* extractSnippet(const char* content) {
    //TODO: extract snippet
    //TODO: print snippet
    return "";
}

int main(int argc, const char* argv[]) {
    //TODO: build query from command line args
    //TODO: url-escape query

    char* content = request("similar?order=desc&sort=relevance&title=Hibernate+manytomany");
    json_error_t error;
    json_t* response = json_loads(content, 0, &error);
    free(content);

    json_t* items = json_object_get(response, "items");
    int count = json_array_size(items);
    json_t* answer;
    for (int i = 0; i < count; ++i) {
        answer = json_object_get(json_array_get(items, i), "accepted_answer_id");

        if (answer != NULL) {
            char* url = g_strdup_printf("answers/%d?filter=withbody", (int) json_integer_value(answer));
            content = request(url);
            g_free(url);

            answer = json_loads(content, 0, &error);
            free(content);

            printf(
                "%s\n",
                extractSnippet(
                    json_string_value(json_object_get(json_array_get(json_object_get(response, "items"), 0), "body"))
                )
            );

            //TODO: first make sure there was a snippet extracted
            break;
        }
    }

    //TODO; process more pages maybe?

    return 0;
}
