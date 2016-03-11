<?php

/**
 * This file is part of the PopStack (PHP implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/* TODO
 * build tool (for .phar)
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features (like overloaded operators)
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 * "proper" HTTP client setup (headers, gzip as a middleware)
 */

function fetch(string $call) {
    return json_decode(
        gzdecode(file_get_contents('http://api.stackexchange.com/2.2/' . $call . '&site=stackoverflow'))
    );
}

function extractSnippet(string $content) {
    if (preg_match('#<pre><code>(.*?)</code></pre>#s', $content, $match) !== false) {
        return htmlspecialchars_decode(trim($match[1])) . "\n";
    }

    return '';
}

$query = urlencode(implode(array_slice($_SERVER['argv'], 1), ' '));

$items = fetch('similar?order=desc&sort=relevance&title=' . $query)->items;
foreach ($items as $item) {
    if (isset($item->accepted_answer_id)) {
        echo extractSnippet(
            fetch('answers/' . $item->accepted_answer_id . '?filter=withbody')->items[0]->body
        );

        //TODO: first make sure there was a snippet extracted
        break;
    }
}

//TODO: process more pages maybe?
