##
# This file is part of the PopStack (Elixir implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

defmodule Popstack.Mixfile do
    use Mix.Project

    def project do
        [
            app: :popstack,
            version: "0.0.1",
            elixir: "~> 1.2",
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env == :prod,
            deps: deps
        ]
    end

    def application do
        [ applications: [:httpotion] ]
    end

    defp deps do
        [
            {:httpotion, "~> 2.2.0"}
        ]
    end
end
