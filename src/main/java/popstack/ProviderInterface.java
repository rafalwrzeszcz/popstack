/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

public interface ProviderInterface {
    String search(String query) throws ProviderException;
}
