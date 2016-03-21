/**
 * This file is part of the PopStack (C implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <curl/curl.h>

#include <glib.h>

#include <jansson.h>

#define BUFFER_SIZE (256 * 1024) /* 256 KB */

/*TODO:
 * proper handling of memory allocation/freeing
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 */

typedef struct {
    char* data;
    int pos;
} write_result;

static GRegex* snippet;
static CURL* curl;

static size_t write_response(void* ptr, size_t size, size_t nmemb, void* stream) {
    write_result* result = (write_result*) stream;

    memcpy(result->data + result->pos, ptr, size * nmemb);
    result->pos += size * nmemb;

    return size * nmemb;
}

/*TODO:
 * it's super fast right now at failing with all the NULL-checks
 * but connection/data errors should produce different printout
 */

static char* request(const char* call, ...) {
    char* data = NULL;
    va_list args;
    va_start(args, call);

    data = malloc(BUFFER_SIZE);

    write_result write_result = {
        .data = data,
        .pos = 0
    };

    char* path = g_strdup_vprintf(call, args);
    char* url = g_strconcat("http://api.stackexchange.com/2.2/", path, "&site=stackoverflow", NULL);
    g_free(path);
    va_end(args);

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_response);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &write_result);
    curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, "gzip");

    curl_easy_perform(curl);

    g_free(url);

    /* zero-terminate the result */
    data[write_result.pos] = 0;

    return data;
}

char* extractSnippet(const char* content) {
    GMatchInfo *match_info;
    char* result = NULL;

    if (g_regex_match(snippet, content, 0, &match_info)) {
        result = g_match_info_fetch(match_info, 1);
        //TODO: unescape
        result = g_strstrip(result);
    }

    g_match_info_free(match_info);
    return result;
}

char* buildQuery(int argc, const char* argv[]) {
    char* parts[argc];
    int i;

    for (i = 1; i < argc; ++i) {
        parts[i - 1] = g_strdup(argv[i]);
    }
    parts[argc - 1] = NULL;
    char* query = g_strjoinv(" ", parts);

    // free temporary copies
    for (i = 1; i < argc; ++i) {
        g_free(parts[i - 1]);
    }

    char* escaped = curl_easy_escape(curl, query, 0);
    g_free(query);
    return escaped;
}

int main(int argc, const char* argv[]) {
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();

    char* query = buildQuery(argc, argv);
    char* content = request("similar?order=desc&sort=relevance&title=%s", query);
    curl_free(query);

    json_error_t error;
    json_t* response = json_loads(content, 0, &error);
    free(content);

    if (!response) {
        printf("%s\n", error.text);
        return 1;
    }

    snippet = g_regex_new("<pre><code>(.*?)</code></pre>", G_REGEX_DOTALL, 0, NULL);

    json_t* items = json_object_get(response, "items");
    int count = json_array_size(items);
    json_t* answer;
    char* text = NULL;
    for (int i = 0; i < count; ++i) {
        answer = json_object_get(json_array_get(items, i), "accepted_answer_id");

        if (answer != NULL) {
            content = request("answers/%d?filter=withbody", (int) json_integer_value(answer));
            answer = json_loads(content, 0, &error);
            free(content);

            if (!response) {
                printf("%s\n", error.text);
                return 1;
            }

            text = extractSnippet(
                json_string_value(json_object_get(json_array_get(json_object_get(answer, "items"), 0), "body"))
            );
            json_decref(answer);

            if (text) {
                break;
            }
        }
    }
    json_decref(response);

    //TODO; process more pages maybe?

    curl_easy_cleanup(curl);
    curl_global_cleanup();

    g_regex_unref(snippet);

    if (text) {
        printf("%s\n", text);
        g_free(text);
    } else {
        printf("Your only help is http://google.com/ man!\n");
    }

    return 0;
}
