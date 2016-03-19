/**
 * This file is part of the PopStack (Kotlin implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import java.net.URLEncoder;

import com.github.kittinunf.fuel.Fuel;

import org.json.JSONObject;

/*TODO:
 * build consolidated jar (shade plugin)
 * maven project setup
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features (like overloaded operators)
 * logs
 * optimize
 */

val snippet = Regex("<pre><code>(.*?)</code></pre>", RegexOption.DOT_MATCHES_ALL);

fun fetch(call: String): JSONObject {
    val result = Fuel
        .get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
        .responseString()
        .component3();
    return JSONObject(result);
}

fun extractSnippet(content: String): String? {
    val match = snippet.find(content);
    if (match != null) {
        return match.groups[1]?.value?.trim()
            ?.replace("&lt;", "<")
            ?.replace("&gt;", ">")
            ?.replace("&quot;", "\"")
            // this one has to be the last one!
            ?.replace("&amp;", "&");
    }

    return null;
}

fun main(args: Array<String>): Unit {
    val query = args.joinToString(" ");

    try {
        var items = fetch("similar?order=desc&sort=relevance&title=" + URLEncoder.encode(query, "UTF-8"))
            .getJSONArray("items");
        var length = items.length();
        var item: JSONObject;
        var i = 0;
        var answer: String? = null;
        while (i < length) {
            item = items.getJSONObject(i);

            if (item.has("accepted_answer_id")) {
                val id = item.getInt("accepted_answer_id");
                answer = extractSnippet(
                    //TODO: don't really like that - is there any way to simply convert form Int to String?
                    fetch("answers/$id?filter=withbody")
                        .getJSONArray("items")
                        .getJSONObject(0)
                        .getString("body")
                );

                if (answer != null) {
                    break;
                }
            }

            ++i;
        }

        //TODO: process more pages maybe?

        if (answer != null) {
            println(answer);
        } else {
            println("Your only help is http://google.com/ man!");
        }
    } catch (error: Exception) {
        println(error);
    }
}
