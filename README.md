**Crystal** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

All you need to run it is to have **Crystal** compiler
[installed](http://crystal-lang.org/docs/installation/index.html).

And then build the project with:

```
crystal build popstack.cr
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
