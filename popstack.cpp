/**
 * This file is part of the PopStack (C++ implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#include <exception>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include <boost/algorithm/string/join.hpp>

#include "pplx/pplxtasks.h"

#include "src/PopStack/ProviderInterface.hpp"
#include "src/PopStack/StackOverflow/StackOverflowProvider.hpp"

using std::auto_ptr;
using std::cout;
using std::endl;
using std::exception;
using std::string;
using std::stringstream;
using std::vector;

using boost::algorithm::join;

using PopStack::ProviderInterface;
using PopStack::StackOverflow::StackOverflowProvider;

using pplx::task;

/* TODO
 * code style
 * static code analysis
 * unit tests
 * auto documentation
 * logs
 */

int main(int argc, const char* argv[]) {
    vector< string > arguments(argv + 1, argv + argc);
    auto_ptr< ProviderInterface > provider(new StackOverflowProvider());

    try {
        provider.get()->search(join(arguments, " "))
            .then([](optional< string > answer) -> void {
                    if (answer) {
                        cout << answer.get() << endl;
                    } else {
                        cout << "Your only help is http://google.com/ man!" << endl;
                    }
            })
            .wait();
    } catch (exception& error) {
        cout << error.what() << endl;
    }

    return 0;
}
