/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

import org.apache.commons.lang3.StringUtils;

import popstack.ProviderInterface;
import popstack.stackoverflow.StackOverflowProvider;

/*TODO:
 * build consolidated jar (shade plugin)
 * maven project setup
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 */

public class Popstack {
    public static void main(String[] args) {
        String query = StringUtils.join(args, " ");
        ProviderInterface provider = new StackOverflowProvider();

        try {
            String answer = provider.search(query);

            if (answer != null) {
                System.out.println(answer);
            } else {
                System.out.println("Your only help is http://google.com/ man!");
            }
        } catch (Exception error) {
            System.out.println(error.getMessage());
        }
    }
}
