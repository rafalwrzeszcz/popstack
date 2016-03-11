<?php

/**
 * This file is part of the PopStack (PHP implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

function fetch(string $call) {
    return json_decode(
        gzdecode(file_get_contents('http://api.stackexchange.com/2.2/' . $call . '&site=stackoverflow'))
    );
}

function extractSnippet(string $content) {
    return '';
}

$items = fetch('similar?order=desc&sort=relevance&title=Hibernate+manytomany')->items;
foreach ($items as $item) {
    if (isset($item->accepted_answer_id)) {
        echo extractSnippet(
            fetch('answers/' . $item->accepted_answer_id . '?filter=withbody')->items[0]->body
        ), "\n";

        //TODO: first make sure there was a snippet extracted
        break;
    }
}

//TODO: process more pages maybe?
