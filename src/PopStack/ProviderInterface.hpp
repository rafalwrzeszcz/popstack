/**
 * This file is part of the PopStack (C++ implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#pragma once

#include <string>

#include <boost/optional/optional.hpp>

#include "pplx/pplxtasks.h"

using std::string;

using boost::optional;

using pplx::task;

namespace PopStack {
    class ProviderInterface {
    public:
        virtual task< optional< string > > search(string query) = 0;
    };
}
