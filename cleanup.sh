##
# This file is part of the PopStack (D implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo rm /etc/apt/sources.list.d/d.list
sudo apt-get remove --purge -y d-apt-keyring dmd-bin
sudo apt-get autoremove --purge -y
sudo apt-get update
