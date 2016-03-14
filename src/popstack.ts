/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/// <reference path="typings/node/node.d.ts"/>

/* TODO:
 * static code analysis
 * unit tests
 * auto documentation
 * exception handling
 * use more language features
 * logs
 */

import { get, IncomingMessage } from "http";
import { createGunzip, Gunzip } from "zlib";

interface Consumer {
    (data: Object): void;
}

interface Question {
    accepted_answer_id?: number;
}

interface QuestionsResponse {
    items: Question[];
}

interface Answer {
    body: string;
}

interface AnswersResponse {
    items: Answer[];
}

// todo: use promise
function fetch(call: String, consumer: Consumer): void {
    get("http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow", function(response: IncomingMessage): void {
            let gunzip: Gunzip = createGunzip();
            let buffer: string = "";

            response.pipe(gunzip);
            gunzip.on("data", function(chunk: string): void {
                    buffer += chunk;
            });
            gunzip.on("end", function(): void {
                    consumer(JSON.parse(buffer));
            });
    });
}

let snippet: RegExp = /<pre><code>([\s\S]*?)<\/code><\/pre>/;

function extractSnippet(content: string): string {
    let match: string[] = content.match(snippet);
    if (match) {
        return match[1].trim();
        // todo: unescape
    }

    return "";
}

let query: string = process.argv.slice(2).join(" ");

fetch("similar?order=desc&sort=relevance&title=" + encodeURIComponent(query), function(questions: Object): void {
        let items: Question[] = (questions as QuestionsResponse).items;
        for (let i: number = 0; i < items.length; ++i) {
            if ("accepted_answer_id" in items[i]) {
                fetch("answers/" + items[i].accepted_answer_id + "?filter=withbody", function(answers: Object): void {
                        let answer: Answer = (answers as AnswersResponse).items[0];

                        console.log(extractSnippet(answer.body));
                });

                // todo: first make sure there was a snippet extracted
                break;
            }
        }

        // todo: process more pages maybe?
});
