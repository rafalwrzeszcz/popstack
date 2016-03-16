**Go** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You just need [**Go**](https://golang.org) to build the project:

```
./build.sh
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
