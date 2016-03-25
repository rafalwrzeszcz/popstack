<?hh

/**
 * This file is part of the PopStack (Hack implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

require(__DIR__ . '/vendor/autoload.php');

use PopStack\StackOverflow\StackOverflowProvider;

/* TODO
 * build tool (for .phar)
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

$query = implode(array_slice($_SERVER['argv'], 1), ' ');
$provider = new StackOverflowProvider();

try {
    $answer = $provider->search($query);

    if ($answer != null) {
        echo $answer, "\n";
    } else {
        echo 'Your only help is http://google.com/ man!', "\n";
    }
} catch (Exception $error) {
    echo $error->getMessage(), "\n";
}
