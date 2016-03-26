/**
 * This file is part of the PopStack (D implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

import std.array: join;
import std.stdio: writeln;

import popstack.provider: ProviderInterface;
import popstack.stackoverflow: StackOverflowProvider;

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

void main(string[] args) {
    auto query = join(args[1..$], " ");

    try {
        ProviderInterface provider = new StackOverflowProvider();
        string answer = provider.search(query);

        if (answer) {
            writeln(answer);
        } else {
            writeln("Your only help is http://google.com/ man!");
        }
    } catch (Exception error) {
        writeln(error.msg);
    }
}
