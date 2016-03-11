##
# This file is part of the PopStack (Ceylon implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo rm /etc/apt/sources.list.d/ceylon.list
sudo apt-get remove --purge -y ceylon-1.2.1
sudo apt-get autoremove --purge -y
sudo apt-get update
