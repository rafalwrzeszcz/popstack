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

echo fetch('similar?order=desc&sort=relevance&title=Hibernate+manytomany')->items;
