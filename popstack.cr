##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "http/client"
require "json"
require "uri"

#TODO
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# exception handling
# use more language features
# logs
# optimize (try to keep some parts of repetitive executions as instanced objects)

#TODO: get rid of globals after redesigning into some proper project structure
$client = HTTP::Client.new "api.stackexchange.com"
$snippet = /<pre><code>(.*?)<\/code><\/pre>/m

def fetch(call)
    response = $client.get "/2.2/" + call + "&site=stackoverflow"
    return JSON.parse(response.body)
end

def extractSnippet(content)
    match = $snippet.match(content)
    if match
        return match[1].strip
        #TODO: unescape
    end

    return ""
end

query = URI.escape(ARGV.join(" "))

fetch("similar?order=desc&sort=relevance&title=" + query)["items"].each { |item|
    id = item["accepted_answer_id"]?
    if id
        puts extractSnippet(fetch("answers/" + id.to_s + "?filter=withbody")["items"][0]["body"].to_s)

        #TODO: first make sure there was a snippet extracted
        break
    end
}

#TODO: process more pages maybe?

$client.close()
