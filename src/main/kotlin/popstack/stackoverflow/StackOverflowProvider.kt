/**
 * This file is part of the PopStack (Kotlin implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack.stackoverflow;

import java.net.URLEncoder;

import com.github.kittinunf.fuel.Fuel;

import org.json.JSONObject;

import popstack.ProviderInterface;

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

class StackOverflowProvider : ProviderInterface {
    override fun search(query: String): String? {
        var items = fetch("similar?order=desc&sort=relevance&title=" + URLEncoder.encode(query, "UTF-8"))
            .getJSONArray("items");
        var length = items.length();
        var item: JSONObject;
        var i = 0;
        while (i < length) {
            item = items.getJSONObject(i);

            if (item.has("accepted_answer_id")) {
                val answer = extractSnippet(
                    fetch("answers/" + item.get("accepted_answer_id").toString() + "?filter=withbody")
                        .getJSONArray("items")
                        .getJSONObject(0)
                        .getString("body")
                );

                if (answer != null) {
                    return answer;
                }
            }

            ++i;
        }

        //TODO: process more pages maybe?

        return null;
    }
}
