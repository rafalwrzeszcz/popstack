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

#include "../ProviderInterface.hpp"

using std::string;

using boost::optional;

using pplx::task;

using PopStack::ProviderInterface;

namespace PopStack {
    namespace StackOverflow {
        class StackOverflowProvider : public ProviderInterface {
        public:
            virtual task< optional< string > > search(string query);
        };
    }
}
