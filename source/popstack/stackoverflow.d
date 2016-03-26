/**
 * This file is part of the PopStack (D implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

module popstack.stackoverflow;

import std.conv: to;
import std.json: parseJSON, JSONValue;
import std.net.curl: AutoProtocol, get;
import std.regex: matchFirst, regex;
import std.string: strip;
import std.uri: encode;
import std.xml: decode;
import std.zlib: HeaderFormat, UnCompress;

import popstack.provider: ProviderInterface;

auto snippet = regex(`<pre><code>(.*?)</code></pre>`, "s");

string extractSnippet(string content) {
    auto match = matchFirst(content, snippet);
    if (!match.empty) {
        return decode(strip(match[1]));
    }

    return null;
}

JSONValue fetch(string call) {
    auto response = get!(AutoProtocol, ubyte)("http://api.stackexchange.com/2.2/" ~ call ~ "&site=stackoverflow");
    auto inflator = new UnCompress(HeaderFormat.gzip);
    const(void)[] buffer;
    char[] content = [];

    do {
        buffer = inflator.uncompress(response);
        content ~= to!(char[])(buffer);
    } while(buffer.length > 0);
    return parseJSON(content);
}

class StackOverflowProvider : ProviderInterface {
    string search(string query) {
        auto data = fetch("similar?order=desc&sort=relevance&title=" ~ encode(query))["items"];
        JSONValue[string] properties;
        string answer;
        foreach (JSONValue item; data.array()) {
            properties = item.object();
            if ("accepted_answer_id" in properties) {
                data = fetch(
                    "answers/" ~ to!string(properties["accepted_answer_id"].integer()) ~ "?filter=withbody"
                );
                answer = extractSnippet(data["items"][0]["body"].str());

                if (answer) {
                    return answer;
                }
            }
        }

        //TODO: process more pages maybe?

        return null;
    }
}
