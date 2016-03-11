##
# This file is part of the PopStack (Crystal implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo rm /etc/apt/sources.list.d/crystal.list
sudo apt-get remove --purge -y crystal
sudo apt-get autoremove --purge -y
sudo apt-get update
