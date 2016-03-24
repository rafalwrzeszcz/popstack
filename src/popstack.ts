/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/* TODO:
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

import ProviderInterface from "./PopStack/ProviderInterface";
import StackOverflowProvider from "./PopStack/StackOverflow/StackOverflowProvider";

let query: string = process.argv.slice(2).join(" ");

let provider: ProviderInterface = new StackOverflowProvider();
provider.search(query)
    .then(function(answer: string): void {
            if (answer) {
                console.log(answer);
            } else {
                console.log("Your only help is http://google.com/ man!");
            }
    })
    .catch(function(error: string): void {
            console.log(error);
    });
