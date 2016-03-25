/**
 * This file is part of the PopStack (Java implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

package popstack;

public class ProviderException extends Exception {
    private static final long serialVersionUID = 0;

    public ProviderException(String message) {
        super(message);
    }

    public ProviderException(Throwable cause) {
        super(cause);
    }
}
