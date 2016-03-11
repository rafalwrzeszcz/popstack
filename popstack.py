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
# build tool
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# exception handling
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

    return ""

query = " ".join(sys.argv[1:])

for post in fetch("similar?order=desc&sort=relevance&title=" + urllib.parse.quote(query, ""))["items"]:
    if "accepted_answer_id" in post:
        answer = fetch("answers/" + str(post["accepted_answer_id"]) + "?filter=withbody")["items"][0]
        print(extractSnippet(answer["body"]))
        #TODO: first make sure there was a snippet extracted
        break
    #TODO: process more pages maybe?
