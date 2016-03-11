/**
 * This file is part of the PopStack (Kotlin implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import com.github.kittinunf.fuel.Fuel;
import com.github.kittinunf.fuel.core.Request;
import com.github.kittinunf.fuel.core.Response;

fun fetch(call: String): String {
    val (request: Request, response: Response, result: String) = Fuel
        .get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
        .responseString();
    return result;
}

fun main(args: Array<String>) {
    println(fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany"));
}
