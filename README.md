**C** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You need C compiler (I use **GCC**, but there is no magic in the code, it should work smoothly with **CLang** and any
other major compiler) and few libraries (remember that for compiling the code, you need also their development versions
with headers):

- libcurl4 (`libcurl4-openssl-dev`);
- libglib2 (`libglib2.0-dev`);
- libjasson (`libjansson4 libjansson-dev`).

Names listed here are based on **Debian** packages, but I'm pretty sure that packages in other distribution will be
named similarily.

Once you have all of the libs installed, just run `cmake . && make` and it should produce `popstack` executable.

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep <regexp> $(git rev-list --all)
```
