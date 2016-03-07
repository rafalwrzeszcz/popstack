##
# This file is part of the PopStack (C++ implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

cd vendor/casablanca/Release
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
