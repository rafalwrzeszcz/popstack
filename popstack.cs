/**
 * This file is part of the PopStack (C# implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

using System;

using ProviderInterface = PopStack.ProviderInterface;
using StackOverflowProvider = PopStack.StackOverflow.StackOverflowProvider;

/* TODO
 * build tool
 * dependency management
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

namespace PopStack
{
    class PopStack
    {
        public static void Main(string[] args)
        {
            string query = String.Join(" ", args);
            ProviderInterface provider = new StackOverflowProvider();

            try {
                string answer = provider.search(query);

                if (answer != null) {
                    Console.WriteLine(answer);
                } else {
                    Console.WriteLine("Your only help is http://google.com/ man!");
                }
            } catch (Exception error) {
                Console.WriteLine(error.Message);
            }
        }
    }
}
