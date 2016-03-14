##
# This file is part of the PopStack (Rust implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

sudo apt-get remove --purge -y gdb
sudo apt-get autoremove --purge -y
sudo rm -fr \
    /usr/local/bin/{cargo,rustc,rustdoc,rust-gdb} \
    /usr/local/etc/bash_completion.d \
    /usr/local/lib/*-6a154fe0.so \
    /usr/local/lib/rustlib \
    /usr/local/man/man1 \
    /usr/local/share/doc \
    /usr/local/share/man
