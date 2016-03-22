/**
 * This file is part of the PopStack (TypeScript implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

declare module "html-entities" {
    export class XmlEntities {
        decode(content: string): string;
    }
}
