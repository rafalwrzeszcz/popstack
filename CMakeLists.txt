##
# This file is part of the PopStack (C++ implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
project(popstack CXX)
add_executable(popstack popstack.cpp src/PopStack/StackOverflow/StackOverflowProvider.cpp)

set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")

include(ExternalProject)

ExternalProject_Add(cpprest
    PREFIX vendor/casablanca
    SOURCE_DIR vendor/casablanca/Release
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0)

find_package(PkgConfig)
#TODO: thread required by cpprest - can we somehow get rid of transitive dependencies?
find_package(Boost REQUIRED COMPONENTS system iostreams regex thread)

pkg_check_modules(LIBSSL REQUIRED libssl)

add_dependencies(popstack cpprest)
include_directories(vendor/casablanca/Release/include)
target_link_libraries(popstack
    ${Boost_LIBRARIES}
    ${LIBSSL_LIBRARIES}
    #TODO: required by cpprest - can we somehow get rid of it?
    pthread
    #TODO: any better way?
    ${CMAKE_CURRENT_BINARY_DIR}/vendor/casablanca/src/cpprest-build/Binaries/libcpprest.a)
