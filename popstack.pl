##
# This file is part of the PopStack (Perl implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

use strict;
use warnings;

use HTML::Entities;
use HTTP::Client;
use IO::Uncompress::Gunzip qw(gunzip);
use JSON;
use URI::Encode qw(uri_encode);

# TODO:
# dependency management
# code style
# static code analysis
# unit tests
# auto documentation
# exception handling
# use more language features (and investigate currently used ones)
# logs
# optimize (try to keep some parts of repetitive executions as instanced objects)

my $client = HTTP::Client->new();

sub fetch {
    my ($call) = @_;
    my $buffer = $client->get("http://api.stackexchange.com/2.2/" . $call . "&site=stackoverflow");
    my $response;

    gunzip \$buffer => \$response;
    return decode_json($response);
}

# TODO: it shuold just accept $content, $key should be dropped in caller
sub extractSnippet {
    my ($key, $content) = @_;

    if (my ($snippet) = $content =~ /<pre><code>(.*?)<\/code><\/pre>/s) {
        return decode_entities($snippet);
    }

    return "";
}

# TODO: any way to shorten this?
my $query = uri_encode(join(" ", @ARGV));

my $data = fetch("similar?order=desc&sort=relevance&title=" . $query);
my $items = %$data{"items"};
foreach (@$items) {
    if (defined "accepted_answer_id") {
        my ($key, $id) = %$_{"accepted_answer_id"};
        $data = fetch("answers/" . $id . "?filter=withbody");
        $items = %$data{"items"};
        my $item = @$items[0];
        print extractSnippet(%$item{"body"});

        # TODO: first make sure there was a snippet extracted
        last;
    }
}

# TODO: process more pages maybe?
