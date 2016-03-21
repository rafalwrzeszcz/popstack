##
# This file is part of the PopStack (C implementation).
#
# @license http://mit-license.org/ The MIT license
# @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
##

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
project(popstack C)
add_executable(popstack popstack.c)

set(CMAKE_C_FLAGS "-std=c11 ${CMAKE_C_FLAGS}")

find_package(PkgConfig)

pkg_check_modules(GLIB2 REQUIRED glib-2.0)
pkg_check_modules(JANSSON REQUIRED jansson)
pkg_check_modules(CURL REQUIRED libcurl)

target_link_libraries(popstack ${GLIB2_LIBRARIES} ${JANSSON_LIBRARIES} ${CURL_LIBRARIES})
include_directories(${GLIB2_INCLUDE_DIRS})
