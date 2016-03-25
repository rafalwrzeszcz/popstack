<?hh

/**
 * This file is part of the PopStack (Hack implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

namespace PopStack;

interface ProviderInterface {
    public function search(string $query): ?string;
}
