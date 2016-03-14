##
# This file is part of the PopStack (Hack implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo rm /etc/apt/sources.list.d/hhvm.list
sudo apt-get remove --purge -y hhvm
sudo apt-get autoremove --purge -y
sudo apt-get update
