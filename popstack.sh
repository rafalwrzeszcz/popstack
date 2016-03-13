##
# This file is part of the PopStack (Bash implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

function fetch() {
    curl -s "http://api.stackexchange.com/2.2/$1&site=stackoverflow" \
        | gunzip
}

ANSWER_ID=`fetch "similar?order=desc&sort=relevance&title=Hibernate+manytomany" \
    | jshon -QC -e items -a -e accepted_answer_id \
    | head -n 1`

fetch "answers/$ANSWER_ID?filter=withbody" \
    | jshon -QC -e items -e 0 -e body -u \
    | sed -n '1h;1!H;${;g;s/^.*<pre><code>\(.*\)<\/code><\/pre>.*$/\1/g;p;}' \
    | grep -v '^$'
