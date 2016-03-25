##
# This file is part of the PopStack (Python implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

import sys

from popstack.stackoverflow import StackOverflowProvider

# TODO:
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# logs

query = " ".join(sys.argv[1:])

try:
    provider = StackOverflowProvider()
    answer = provider.search(query)

    if answer is not None:
        print(answer)
    else:
        print("Your only help is http://google.com/ man!");
except Exception as error:
    print(type(error).__name__ + ": " + str(error))
