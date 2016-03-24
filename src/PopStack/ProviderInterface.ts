/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

/// <reference path="../typings/bluebird/bluebird.d.ts"/>

import * as Promise from "bluebird";

interface ProviderInterface {
    search(query: string): Promise<string>;
}

export default ProviderInterface;
