##
# This file is part of the PopStack (Python implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

import html
import re
import requests
import sys
import urllib.parse

# TODO:
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# logs
# optimize (try to keep some parts of repetitive executions as instanced objects)

snippet = re.compile("<pre><code>(.*?)</code></pre>", re.S)

def fetch(call):
    response = requests.get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow")

    return response.json()

def extractSnippet(content):
    match = snippet.search(content)
    if match is not None:
        return html.unescape(match.group(1).strip())

    return None

query = " ".join(sys.argv[1:])

try:
    answer = None
    for post in fetch("similar?order=desc&sort=relevance&title=" + urllib.parse.quote(query, ""))["items"]:

        if "accepted_answer_id" in post:
            answer = extractSnippet(
                fetch("answers/" + str(post["accepted_answer_id"]) + "?filter=withbody")["items"][0]["body"]
            )

            if answer is not None:
                break

    #TODO: process more pages maybe?

    if answer is not None:
        print(answer)
    else:
        print("Your only help is http://google.com/ man!");
except Exception as error:
    print(type(error).__name__ + ": " + str(error))
