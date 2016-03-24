/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/// <reference path="../../typings/node/node.d.ts"/>
/// <reference path="../../typings/bluebird/bluebird.d.ts"/>
/// <reference path="../../html-entities.d.ts"/>

import { get, IncomingMessage } from "http";
import { createGunzip, Gunzip } from "zlib";

import * as Promise from "bluebird";
import { XmlEntities } from "html-entities";

import { Consumer } from "../utils";
import ProviderInterface from "../ProviderInterface";

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

export default class StackOverflowProvider implements ProviderInterface {
    private static snippet: RegExp = /<pre><code>([\s\S]*?)<\/code><\/pre>/;
    private static entities: XmlEntities = new XmlEntities();

    private static fetch<Result>(call: string): Promise<Result> {
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

    private static extractSnippet(content: string): string {
        let match: string[] = content.match(StackOverflowProvider.snippet);
        if (match) {
            return StackOverflowProvider.entities.decode(match[1]).trim();
        }

        return null;
    }

    public search(query: string): Promise<string> {
        return StackOverflowProvider
            .fetch("similar?order=desc&sort=relevance&title=" + encodeURIComponent(query))
            .then(function(questions: QuestionsResponse): Promise<string> {
                    let answer: string;
                    return Promise.coroutine(function*(items: Question[]): IterableIterator<Promise<void>> {
                            for (let i: number = 0; i < items.length; ++i) {
                                if ("accepted_answer_id" in items[i]) {
                                    yield StackOverflowProvider
                                        .fetch("answers/" + items[i].accepted_answer_id + "?filter=withbody")
                                        .then(function(answers: AnswersResponse): void {
                                                answer = StackOverflowProvider
                                                    .extractSnippet(answers.items[0].body);
                                        });

                                    if (answer) {
                                        break;
                                    }
                                }
                            }

                            // todo: process more pages maybe?
                    })(questions.items)
                        .then(function(): string {
                                return answer;
                        });
            });
    }
}
