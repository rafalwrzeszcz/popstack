**D** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

All you need to have is a [**D** compiler](http://dlang.org) with up-to-date standard library. I use official `dmd`,
but `ldc` and `gdc` should work as well.

Then just compile the source file:

```
dmd popstack.d
```

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep <regexp> $(git rev-list --all)
```
