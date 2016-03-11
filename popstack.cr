##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "http/client"
require "json"

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

def fetch(call)
    response = $client.get "/2.2/" + call + "&site=stackoverflow"
    return JSON.parse(response.body)
end

def extractSnippet(content)
    #TODO: match, extract, trim, unescape
    return content
end

#TODO: build query from command line arguments
fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")["items"].each do |item|
    id = item["accepted_answer_id"]?
    if id
        print(extractSnippet(fetch("answers/" + id.to_s + "?filter=withbody")["items"][0]["body"]))

        #TODO: first make sure there was a snippet extracted
        break
    end
end

#TODO: process more pages maybe?

$client.close()
