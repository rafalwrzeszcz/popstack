**Perl** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

**Perl** is usually available on most of **Linux** distributions. If not, then for sure it's available in your
distribution repository and you can easily install it with your package manager.

Before running the script, you have to install the dependencies - use the helper script:

```
./cpan.sh
```

# Usage

```
perl popstack.pl [query]
```

For example:

```
$ perl popstack.pl grep history
git grep <regexp> $(git rev-list --all)
```
