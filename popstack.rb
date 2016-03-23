##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "cgi"
require "json"
require "net/http"

#TODO
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# use more language features
# logs
# optimize (try to keep some parts of repetitive executions as instanced objects)

class StackOverflowApiException < Exception
end

def fetch(call)
    response = Net::HTTP.get("api.stackexchange.com", "/2.2/" + call + "&site=stackoverflow")
    data = JSON.parse(response)

    if data.key?("error_message")
        raise StackOverflowApiException, data["error_message"]
    end

    return data
end

#TODO: get rid of global variables
$snippet = /<pre><code>(.*?)<\/code><\/pre>/m

def extractSnippet(content)
    match = $snippet.match(content)
    if match
        return CGI.unescapeHTML(match[1].strip)
    end

    return nil
end

query = URI.escape(ARGV.join(" "))

begin
    answer = nil
    fetch("similar?order=desc&sort=relevance&title=" + query)["items"].each { |item|
        if item.key?("accepted_answer_id")
            answer = extractSnippet(
                fetch("answers/" + item["accepted_answer_id"].to_s + "?filter=withbody")["items"][0]["body"]
            )

            unless answer.nil?
                break
            end
        end
    }

    #TODO: process more pages maybe?

    unless answer.nil?
        puts answer
    else
        puts "Your only help is http://google.com/ man!"
    end
rescue Exception => error
    puts error.message
end
