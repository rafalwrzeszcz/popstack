##
# This file is part of the PopStack (Objective-C implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

gcc popstack.m \
    -Wall \
    -O3 \
    -lobjc \
    -o popstack \
    -I/usr/include/glib-2.0 \
    -I/usr/lib/x86_64-linux-gnu/glib-2.0/include \
    -lglib-2.0 \
    -lcurl \
    -ljansson
