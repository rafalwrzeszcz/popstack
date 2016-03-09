/**
 * This file is part of the PopStack (Go implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package main

import "encoding/json"
import "fmt"
import "io/ioutil"
import "net/http"
import "strconv"

func parse(content []byte) map[string]interface{} {
    var data map[string]interface{}
    _ = json.Unmarshal(content, &data)
    return data
}

func fetch(call string) map[string]interface{} {
    var response *http.Response
    var buffer []byte

    response, _ = http.Get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
    buffer, _ = ioutil.ReadAll(response.Body)
    response.Body.Close()
    return parse(buffer)
}

func extractSnippet(body string) string {
    fmt.Println(body)
    //TODO: match, extract, unescape, trim
    return ""
}

func main() {
    var response map[string]interface{} = fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")
    var items []interface{} = response["items"].([]interface{})
    var item interface{}
    var data map[string]interface{}
    var answer interface{}
    var exists bool
    for _, item = range items {
        data = item.(map[string]interface{})
        answer, exists = data["accepted_answer_id"]
        if exists {
            response = fetch("answers/" + strconv.FormatFloat(answer.(float64), 'f', -1, 64) + "?filter=withbody")
            item = response["items"].([]interface{})[0]
            fmt.Println(extractSnippet(item.(map[string]interface{})["body"].(string)))

            //TODO: first make sure there was a snippet extracted
            break
        }
    }

    //TODO; process more pages maybe?
}
