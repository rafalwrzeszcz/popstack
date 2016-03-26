##
# This file is part of the PopStack (C# implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

mcs popstack.cs PopStack/ProviderInterface.cs PopStack/StackOverflow/StackOverflowProvider.cs \
    -r:System.Web.dll \
    -r:vendor/Json.NET/Bin/Net45/Newtonsoft.Json.dll
