/**
 * This file is part of the PopStack (D implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import std.conv, std.json, std.net.curl, std.stdio, std.zlib;

JSONValue fetch(string call) {
    ubyte[] response = get!(AutoProtocol,ubyte)("http://api.stackexchange.com/2.2/" ~ call ~ "&site=stackoverflow");
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
    //TODO: match, extract, trim, unescape
    return content;
}

void main() {
    JSONValue data = fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")["items"];
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
