##
# This file is part of the PopStack (Python implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

import html
import re
import requests
import urllib.parse

snippet = re.compile("<pre><code>(.*?)</code></pre>", re.S)

def fetch(call):
    response = requests.get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")
    data = response.json()

    if "error_message" in data:
        raise ApiException(data["error_message"])

    return data

def extractSnippet(content):
    match = snippet.search(content)
    if match is not None:
        return html.unescape(match.group(1).strip())

    return None

class ApiException(Exception):
    pass

class StackOverflowProvider:
    def search(self, query):
        for post in fetch("similar?order=desc&sort=relevance&title=" + urllib.parse.quote(query, ""))["items"]:
            if "accepted_answer_id" in post:
                answer = extractSnippet(
                    fetch("answers/" + str(post["accepted_answer_id"]) + "?filter=withbody")["items"][0]["body"]
                )

                if answer is not None:
                    return answer

        #TODO: process more pages maybe?

        return None
