/**
 * This file is part of the PopStack (Kotlin implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import popstack.stackoverflow.StackOverflowProvider;

/*TODO:
 * build consolidated jar (shade plugin)
 * maven project setup
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

fun main(args: Array<String>): Unit {
    val query = args.joinToString(" ");
    val provider = StackOverflowProvider();

    try {
        val answer = provider.search(query);

        if (answer != null) {
            println(answer);
        } else {
            println("Your only help is http://google.com/ man!");
        }
    } catch (error: Exception) {
        println(error);
    }
}
