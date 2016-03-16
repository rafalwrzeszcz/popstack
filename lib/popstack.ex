##
# This file is part of the PopStack (Elixir implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

#TODO
# code style
# static code analysis
# unit tests
# auto documentation
# exception handling
# use more language features
# logs
# optimize (try to keep some parts of repetitive executions as instanced objects)
# "proper" HTTP client setup (headers, gzip as a middleware?)

defmodule Popstack do
    def fetch(call) do
        HTTPotion.get("http://api.stackexchange.com/2.2/" <> call <> "&site=stackoverflow").body
        |> :zlib.gunzip
        |> JSX.decode!
    end

    def extractSnippet(content) do
        snippet = ~r/<pre><code>(.*?)<\/code><\/pre>/s
        if Regex.match? snippet, content do
            [_, result] = Regex.run snippet, content
            #TODO: unescape
            String.strip result
        else
            ""
        end
    end

    def answer(id) do
        [item] = Popstack.fetch("answers/" <> (to_string id) <> "?filter=withbody")["items"]
        #TODO: first make sure there was a snippet extracted
        Popstack.extractSnippet item["body"]
    end

    def questions([item|tail]) do
        if Map.has_key? item, "accepted_answer_id" do
            answer item["accepted_answer_id"]
        else
            Popstack.questions tail
        end
    end

    def questions([]) do
        #TODO: process more pages maybe?
        ""
    end

    def main(args) do
        #TODO: build query from command line arguments
        Popstack.fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany")["items"]
        |> Popstack.questions
        |> IO.puts
    end
end
