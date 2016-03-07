##
# This file is part of the PopStack (C++ implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

g++ popstack.cpp \
    -Wall \
    -O3 \
    -std=c++11 \
    -o popstack \
    -Ivendor/casablanca/Release/include \
    -Lvendor/casablanca/Release/build/Binaries \
    -lcpprest \
    -lboost_system \
    -lboost_iostreams \
    -lssl \
    -lcrypto
