**C++** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You need C++ compiler (I use **G++**, but there is no magic in the code, it should work smoothly any other major
compiler) and few libraries (remember that for compiling the code, you need also their development versions
with headers):

- boost_system, boost_iostreams, boost_regex (`libboost1.55-all-dev`);
- libssl (`libssl-dev`).

Names listed here are based on **Debian** packages, but I'm pretty sure that packages in other distribution will be
named similarily.

Before compiling PopStack itself, you also have to build one library that is not available as a package - the [**C++
REST SDK**](http://microsoft.github.io/cpprestsdk) by [**Microsoft**](http://microsoft.com). It's bundled with the
project as **Git** submodule, so you can simply do:

```
git submodule update --init && build-casablanca.sh
```

Simple run `cmake . && make` and it will build both the **C++ REST SDK** and **Popstack**.

**Note:** It takes some time to compile **C++ REST SDK** but it's done only for the first time.

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep &lt;regexp&gt; $(git rev-list --all)

```

You might need to point additional path for vendor library:

```
LD_LIBRARY_PATH=`pwd`/vendor/casablanca/Release/build/Binaries/ ./popstack grep history
```

# Known issues

- snippet is not trimmed, so it may contain extra blank lines;
- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet.
