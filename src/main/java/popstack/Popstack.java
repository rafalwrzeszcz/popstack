/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

import org.json.JSONObject;

public class Popstack {
    public static JSONObject fetch(String call) throws UnirestException {
        HttpResponse<JsonNode> response = Unirest.get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
//            .header("accept", "application/json")
            .asJson();
        return response.getBody().getObject();
    }

    public static void main(String[] args) throws UnirestException {
        System.out.println(Popstack.fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany"));
    }
}
