/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/// <reference path="typings/node/node.d.ts"/>

import { get } from "http";
import { createGunzip, Gunzip } from "zlib";

function fetch(call: String): void {
    get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow", function(response) {
        var gunzip: Gunzip = createGunzip()
        var buffer: string = "";

        response.pipe(gunzip);
        gunzip.on("data", function(chunk) {
            buffer += chunk;
        });
        gunzip.on("end", function() {
            console.log(JSON.parse(buffer));
        });
    });
}

fetch("similar?order=desc&sort=relevance&title=Hibernate+manytomany");
