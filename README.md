**Ruby** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

This project is built for **Ruby 2.1**. I have no idea about backward compatibility, but this is version installed in
my system.

# Usage

```
ruby popstack.rb [query]
```

For example:

```
$ ruby popstack.rb grep history
git grep <regexp> $(git rev-list --all)
```
