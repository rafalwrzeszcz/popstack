<?hh

/**
 * This file is part of the PopStack (Hack implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

use GuzzleHttp\Client;

require(__DIR__ . '/vendor/autoload.php');

/* TODO
 * build tool (for .phar)
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * use more language features
 * logs
 * optimize (try to keep some parts of repetitive executions as instanced objects)
 */

function fetch(string $call) {
    $client = new Client();
    $response = $client->get('http://api.stackexchange.com/2.2/' . $call . '&site=stackoverflow');
    return json_decode($response->getBody());
}

function extractSnippet(string $content) {
    $match = [];
    if (preg_match('#<pre><code>(.*?)</code></pre>#s', $content, $match) > 0) {
        return htmlspecialchars_decode(trim($match[1]));
    }

    return null;
}

$query = urlencode(implode(array_slice($_SERVER['argv'], 1), ' '));

try {
    $items = fetch('similar?order=desc&sort=relevance&title=' . $query)->items;
    $answer = null;
    foreach ($items as $item) {
        if (isset($item->accepted_answer_id)) {
            $answer = extractSnippet(
                fetch('answers/' . $item->accepted_answer_id . '?filter=withbody')->items[0]->body
            );

            if ($answer != null) {
                break;
            }
        }
    }

    //TODO: process more pages maybe?

    if ($answer != null) {
        echo $answer, "\n";
    } else {
        echo 'Your only help is http://google.com/ man!', "\n";
    }
} catch (Exception $error) {
    echo $error->getMessage(), "\n";
}
