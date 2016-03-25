##
# This file is part of the PopStack (Ruby implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

require "./popstack/stackoverflow"

#TODO
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# logs

query = ARGV.join(" ")

begin
    provider = PopStack::StackOverflow::Provider.new
    answer = provider.search(query)

    unless answer.nil?
        puts answer
    else
        puts "Your only help is http://google.com/ man!"
    end
rescue Exception => error
    puts error.message
end
