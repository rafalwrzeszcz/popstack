/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

import org.apache.commons.lang3.StringEscapeUtils;

import org.json.JSONArray;
import org.json.JSONObject;

public class Popstack {
    private static final Pattern SNIPPET = Pattern.compile("<pre><code>(.*?)</code></pre>", Pattern.DOTALL);

    public static JSONObject fetch(String call) throws UnirestException {
        HttpResponse<JsonNode> response = Unirest.get("http://api.stackexchange.com/2.2/"
                + call
                + "&site=stackoverflow"
            )
            .asJson();
        return response.getBody().getObject();
    }

    public static String extractSnippet(String content) {
        Matcher match = Popstack.SNIPPET.matcher(content);
        if (match.find()) {
            return StringEscapeUtils.unescapeXml(match.group(1).trim());
        }

        return "";
    }

    public static void main(String[] args) throws UnirestException {
        JSONArray items = Popstack.fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")
            .getJSONArray("items");
        int length = items.length();
        JSONObject item;
        for (int i = 0; i < length; ++i) {
            item = items.getJSONObject(i);

            if (item.has("accepted_answer_id")) {
                String id = String.valueOf(item.getInt("accepted_answer_id"));
                items = Popstack.fetch("answers/" + id + "?filter=withbody").getJSONArray("items");

                System.out.println(
                    Popstack.extractSnippet(items.getJSONObject(0).getString("body"))
                );

                //TODO: first make sure there was a snippet extracted
                break;
            }
        }

        //TODO; process more pages maybe?
    }
}
