/**
 * This file is part of the PopStack (D implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import std.array: join;
import std.conv: to;
import std.json: parseJSON, JSONValue;
import std.net.curl: AutoProtocol, get;
import std.regex: matchFirst, regex;
import std.stdio: writeln;
import std.string: strip;
import std.uri: encode;
import std.xml: decode;
import std.zlib: HeaderFormat, UnCompress;

/* TODO
 * build tool
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects, investigate memory allocation)
 * "proper" HTTP client setup (headers, gzip as a middleware)
 */

auto snippet = regex(`<pre><code>(.*?)</code></pre>`, "s");

JSONValue fetch(string call) {
    ubyte[] response = get!(AutoProtocol, ubyte)("http://api.stackexchange.com/2.2/" ~ call ~ "&site=stackoverflow");
    UnCompress inflator = new UnCompress(HeaderFormat.gzip);
    const(void)[] buffer;
    char[] content = [];

    do {
        buffer = inflator.uncompress(response);
        content ~= to!(char[])(buffer);
    } while(buffer.length > 0);
    return parseJSON(content);
}

string extractSnippet(string content) {
    auto match = matchFirst(content, snippet);
    if (!match.empty) {
        return decode(strip(match[1]));
    }

    return "";
}

void main(string[] args) {
    string query = join(args, " ");
    JSONValue data = fetch("similar?order=desc&sort=relevance&title=" ~ encode(query))["items"];
    JSONValue[string] properties;
    foreach (JSONValue item; data.array()) {
        properties = item.object();
        if ("accepted_answer_id" in properties) {
            data = fetch("answers/" ~ to!string(properties["accepted_answer_id"].integer()) ~ "?filter=withbody");
            writeln(extractSnippet(data["items"][0]["body"].str()));

            //TODO: first make sure there was a snippet extracted
            break;
        }
    }

    //TODO: process more pages maybe?
}
