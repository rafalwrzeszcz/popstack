<?hh

/**
 * This file is part of the PopStack (Hack implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

namespace PopStack\StackOverflow;

use stdClass;

use GuzzleHttp\Client;

use PopStack\ProviderInterface;

class StackOverflowProvider implements ProviderInterface {
    private Client $client;

    public function __construct() {
        $this->client = new Client();
    }

    private function fetch(string $call): stdClass {
        $response = $this->client->get('http://api.stackexchange.com/2.2/' . $call . '&site=stackoverflow');
        return json_decode($response->getBody());
    }

    private static function extractSnippet(string $content): ?string {
        $match = [];
        if (preg_match('#<pre><code>(.*?)</code></pre>#s', $content, $match) > 0) {
            return htmlspecialchars_decode(trim($match[1]));
        }

        return null;
    }

    public function search(string $query): ?string {
        $items = $this->fetch('similar?order=desc&sort=relevance&title=' . urlencode($query))->items;
        foreach ($items as $item) {
            if (isset($item->accepted_answer_id)) {
                $answer = StackOverflowProvider::extractSnippet(
                    $this->fetch('answers/' . $item->accepted_answer_id . '?filter=withbody')->items[0]->body
                );

                if ($answer != null) {
                    return $answer;
                }
            }
        }

        //TODO: process more pages maybe?

        return null;
    }
}
