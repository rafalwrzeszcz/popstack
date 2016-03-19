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
            .gsub("&lt;", "<")
            .gsub("&gt;", ">")
            .gsub("&quot;", "\"")
            # this one has to be the last one!
            .gsub("&amp;", "&")
    end

    return nil
end

query = URI.escape(ARGV.join(" "))

begin
    answer = nil
    fetch("similar?order=desc&sort=relevance&title=" + query)["items"].each { |item|
        id = item["accepted_answer_id"]?
        if id
            answer = extractSnippet(fetch("answers/" + id.to_s + "?filter=withbody")["items"][0]["body"].to_s)
            if answer
                break
            end
        end
    }

    #TODO: process more pages maybe?

    if answer
        puts answer
    else
        puts "Your only help is http://google.com/ man!"
    end
rescue exception
    puts exception.message
end

$client.close()
