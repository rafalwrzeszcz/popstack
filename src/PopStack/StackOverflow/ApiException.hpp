/**
 * This file is part of the PopStack (C++ implementation).
 *
 * @license http://mit-license.org/ The MIT license
 * @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
 */

#pragma once

#include <exception>
#include <string>

using std::exception;
using std::string;

namespace PopStack {
    namespace StackOverflow {

        class ApiException: public exception {
        public:
            ApiException(const string& message) : message(message) {}

            virtual const char* what() const noexcept {
                return this->message.c_str();
            }
        private:
            string message;
        };
    }
}
