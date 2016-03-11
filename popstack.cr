##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "http/client"

#TODO: get rid of globals after redesigning into some proper project structure
$client = HTTP::Client.new "api.stackexchange.com"

#TODO

$client.close()
