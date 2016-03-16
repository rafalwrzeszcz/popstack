##
# This file is part of the PopStack (Elixir implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo rm /etc/apt/sources.list.d/erlang-solutions.list
sudo apt-get remove --purge -y erlang-solutions elixir esl-erlang
sudo apt-get autoremove --purge -y
sudo apt-get update
