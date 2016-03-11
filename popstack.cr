##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "http/client"
require "json"

#TODO: get rid of globals after redesigning into some proper project structure
$client = HTTP::Client.new "api.stackexchange.com"

def fetch(call)
    response = $client.get "/2.2/" + call + "&site=stackoverflow"
    return JSON.parse(response.body)
end

print(fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")["items"])
#TODO

$client.close()
