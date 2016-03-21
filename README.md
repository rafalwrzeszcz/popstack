**Clojure** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

All you need to run it is to have **Clojure** installed - it has a great official
[**Docker** image](https://hub.docker.com/_/clojure/), which I use. Just install it with:

```
docker pull clojure:lein-2.5.3
```

And then build the project with:

```
lein compile
```

# Usage

```
lein run [query]
```

For example:

```
$ lein run grep history
git grep <regexp> $(git rev-list --all)
```
