/**
 * This file is part of the PopStack (Kotlin implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import java.net.URLEncoder;

import com.github.kittinunf.fuel.Fuel;
import com.github.kittinunf.fuel.core.Request;
import com.github.kittinunf.fuel.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

fun fetch(call: String): JSONObject {
    val (request: Request, response: Response, result: String) = Fuel
        .get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
        .responseString();
    return JSONObject(result);
}

fun main(args: Array<String>) {
    val query: String = args.joinToString(" ");

    val items: JSONArray = fetch("similar?order=desc&sort=relevance&title=" + URLEncoder.encode(query))
        .getJSONArray("items");
    
}
