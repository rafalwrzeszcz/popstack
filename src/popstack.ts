/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/// <reference path="typings/node/node.d.ts"/>
/// <reference path="typings/bluebird/bluebird.d.ts"/>
/// <reference path="html-entities.d.ts"/>

/* TODO:
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features
 * logs
 */

import { get, IncomingMessage } from "http";
import { createGunzip, Gunzip } from "zlib";

import * as Promise from "bluebird";
import { XmlEntities } from "html-entities";

interface Consumer<Type> {
    (data: Type): void;
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

interface ErrorResponse {
    error_message: string;
}

function fetch<Result>(call: string): Promise<Result> {
    return new Promise(function(resolve: Consumer<Result>, reject: Consumer<string>): void {
            get(
                "http://api.stackexchange.com/2.2/" + call + "&site=stackoverflow",
                function(response: IncomingMessage): void {
                    let gunzip: Gunzip = createGunzip();
                    let buffer: string = "";

                    response.pipe(gunzip);
                    gunzip.on("data", function(chunk: string): void {
                            buffer += chunk;
                    });
                    gunzip.on("end", function(): void {
                            let result: Object = JSON.parse(buffer);

                            if ("error_message" in result) {
                                reject((result as ErrorResponse).error_message);
                            }

                            resolve(result as Result);
                    });
                    gunzip.on("error", reject);
                }
            ).on("error", reject);
    });
}

let snippet: RegExp = /<pre><code>([\s\S]*?)<\/code><\/pre>/;
let entities: XmlEntities = new XmlEntities();

function extractSnippet(content: string): string {
    let match: string[] = content.match(snippet);
    if (match) {
        return entities.decode(match[1]).trim();
    }

    return "";
}

let query: string = process.argv.slice(2).join(" ");

fetch("similar?order=desc&sort=relevance&title=" + encodeURIComponent(query))
    .then(function(questions: QuestionsResponse): void {
            let items: Question[] = questions.items;
            for (let i: number = 0; i < items.length; ++i) {
                if ("accepted_answer_id" in items[i]) {
                    fetch("answers/" + items[i].accepted_answer_id + "?filter=withbody")
                        .then(function(answers: AnswersResponse): void {
                                let answer: Answer = answers.items[0];

                                console.log(extractSnippet(answer.body));
                        });

                    // todo: first make sure there was a snippet extracted
                    break;
                }
            }

            // todo: process more pages maybe?
    })
    .catch(function(error: string): void {
            console.log(error);
    });
