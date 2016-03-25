##
# This file is part of the PopStack (Ruby implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "cgi"
require "json"
require "net/http"

module PopStack
    module StackOverflow
        class ApiException < Exception
        end

        class Provider
            @@snippet = /<pre><code>(.*?)<\/code><\/pre>/m

            def search(query)
                fetch("similar?order=desc&sort=relevance&title=" + URI.escape(query))["items"].each { |item|
                    if item.key?("accepted_answer_id")
                        answer = extractSnippet(
                            fetch(
                                "answers/" + item["accepted_answer_id"].to_s + "?filter=withbody"
                            )["items"][0]["body"]
                        )

                        unless answer.nil?
                            return answer
                        end
                    end
                }

                #TODO: process more pages maybe?

                return nil
            end

            def fetch(call)
                response = Net::HTTP.get("api.stackexchange.com", "/2.2/" + call + "&site=stackoverflow")
                data = JSON.parse(response)

                if data.key?("error_message")
                    raise ApiException, data["error_message"]
                end

                return data
            end

            def extractSnippet(content)
                match = @@snippet.match(content)
                if match
                    return CGI.unescapeHTML(match[1].strip)
                end

                return nil
            end

            private :fetch, :extractSnippet
        end
    end
end
