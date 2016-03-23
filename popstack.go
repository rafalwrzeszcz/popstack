/**
 * This file is part of the PopStack (Go implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package main

import "encoding/json"
import "fmt"
import "html"
import "io/ioutil"
import "net/http"
import "net/url"
import "os"
import "regexp"
import "strconv"
import "strings"

/* TODO
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * Rust-like result type would save a lot of boilerplate code
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 */

func parse(content []byte) (map[string]interface{}, error) {
    var data map[string]interface{}
    var error = json.Unmarshal(content, &data)
    return data, error
}

func fetch(call string) (map[string]interface{}, error) {
    var response *http.Response
    var buffer []byte
    var cause error

    response, cause = http.Get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
    if cause != nil {
        return nil, cause
    }

    buffer, cause = ioutil.ReadAll(response.Body)
    if cause != nil {
        return nil, cause
    }

    cause = response.Body.Close()
    if cause != nil {
        return nil, cause
    }

    return parse(buffer)
}

func extractSnippet(body string) (string, bool) {
    snippet := regexp.MustCompile("(?s)<pre><code>(.*?)</code></pre>")
    if snippet.MatchString(body) {
        return html.UnescapeString(strings.TrimSpace(snippet.FindStringSubmatch(body)[1])), true
    }

    return "", false
}

func ask(query string) (string, error) {
    var response, cause = fetch("similar?order=desc&sort=relevance&title=" + query)
    if cause != nil {
        return "", cause
    }

    var item, exists = response["error_message"]
    if exists {
        return "", fmt.Errorf("Error response from server: %s", item.(string))
    }

    var items = response["items"].([]interface{})
    var data map[string]interface{}
    var answer interface{}
    var message string
    for _, item = range items {
        data = item.(map[string]interface{})
        answer, exists = data["accepted_answer_id"]
        if exists {
            response, cause = fetch(
                "answers/" + strconv.FormatFloat(answer.(float64), 'f', -1, 64) + "?filter=withbody")
            if cause != nil {
                return "", cause
            }

            item = response["items"].([]interface{})[0]
            message, exists = extractSnippet(item.(map[string]interface{})["body"].(string))
            if exists {
                return message, nil
            }
        }
    }

    //TODO: process more pages maybe?

    return "Your only help is http://google.com/ man!", nil
}

func main() {
    var query = url.QueryEscape(strings.Join(os.Args[1:], " "))

    var answer, cause = ask(query)
    if cause == nil {
        fmt.Println(answer)
    } else {
        fmt.Println(cause)
    }
}
