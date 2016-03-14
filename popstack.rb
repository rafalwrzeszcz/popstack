##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "json"
require "net/http"

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

def fetch(call)
    response = Net::HTTP.get("api.stackexchange.com", "/2.2/" + call + "&site=stackoverflow")
    return JSON.parse(response)
end

fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")["items"].each { |item|
    if item.key?("accepted_answer_id")
        puts item["accepted_answer_id"]

        #TODO: first make sure there was a snippet extracted
        break
    end
}

#TODO: process more pages maybe?
