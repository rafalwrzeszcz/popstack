##
# This file is part of the PopStack (Perl implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

use strict;
use warnings;

use HTTP::Client;
use IO::Uncompress::Gunzip qw(gunzip);

my $client = HTTP::Client->new();

sub fetch {
    my ($call) = @_;
    my $buffer = $client->get("http://api.stackexchange.com/2.2/" . $call . "&site=stackoverflow");
    my $response;

    gunzip \$buffer => \$response;
    return $response;
}

print fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany");
