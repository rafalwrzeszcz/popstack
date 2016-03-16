**Objective-C** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You need **Objective-C** compiler - I have no idea about them, I just use `gobjc` (**GCC**-family). Also few libraries
are needed (remember that for compiling the code, you need also their development versions with headers):

- libcurl4 (`libcurl4-openssl-dev`);
- libglib2 (`libglib2.0-dev`);
- libjasson (`libjansson4 libjansson-dev`).

Names listed here are based on **Debian** packages, but I'm pretty sure that packages in other distribution will be
named similarily.

Once you have all of the libs installed, just run `./build.sh` script and it should produce `popstack` executable.

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep &lt;regexp&gt; $(git rev-list --all)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet.

# Technical details

Right now it's just a plain C code. Hope to play more with real **Objective-C** features later, but it's pain in the
ass to find some idiomatic snippets in the ocean of iOS-crap :/.
