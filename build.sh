##
# This file is part of the PopStack (C implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

gcc popstack.c \
    -Wall \
    -O3 \
    -std=c11 \
    -o popstack \
    -lcurl \
    -ljansson
