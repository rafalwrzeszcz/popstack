/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack.stackoverflow;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import com.mashape.unirest.http.utils.URLParamEncoder;

import org.apache.commons.lang3.StringEscapeUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import popstack.ProviderException;
import popstack.ProviderInterface;

class ApiException extends ProviderException {
    private static final long serialVersionUID = 0;

    public ApiException(Throwable cause) {
        super(cause);
    }
}

class DataException extends ProviderException {
    private static final long serialVersionUID = 0;

    public DataException(String message) {
        super(message);
    }
}

public class StackOverflowProvider implements ProviderInterface {
    private static final Pattern SNIPPET = Pattern.compile("<pre><code>(.*?)</code></pre>", Pattern.DOTALL);

    public static JSONObject fetch(String call) throws DataException, ApiException {
        HttpResponse<JsonNode> response;
        try {
            response = Unirest.get("http://api.stackexchange.com/2.2/"
                    + call
                    + "&site=stackoverflow"
                )
                .asJson();
        } catch (UnirestException error) {
            throw new ApiException(error);
        }

        JSONObject value = response.getBody().getObject();

        if (value.has("error_message")) {
            throw new DataException(value.getString("error_message"));
        }

        return value;
    }

    public static String extractSnippet(String content) {
        Matcher match = StackOverflowProvider.SNIPPET.matcher(content);
        if (match.find()) {
            return StringEscapeUtils.unescapeXml(match.group(1).trim());
        }

        return null;
    }

    @Override
    public String search(String query) throws ProviderException {
        JSONArray items = StackOverflowProvider
            .fetch("similar?order=desc&sort=relevance&title=" + URLParamEncoder.encode(query))
            .getJSONArray("items");
        int length = items.length();
        JSONObject item;
        String answer = null;
        for (int i = 0; i < length; ++i) {
            item = items.getJSONObject(i);

            if (item.has("accepted_answer_id")) {
                String id = String.valueOf(item.getInt("accepted_answer_id"));
                items = StackOverflowProvider.fetch("answers/" + id + "?filter=withbody").getJSONArray("items");

                answer = StackOverflowProvider.extractSnippet(items.getJSONObject(0).getString("body"));

                if (answer != null) {
                    return answer;
                }
            }
        }

        //TODO: process more pages maybe?

        return null;
    }
}
