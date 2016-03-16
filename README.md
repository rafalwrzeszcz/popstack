**Hack** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

To run this project you need [**Hack**](https://docs.hhvm.com/hack/getting-started/getting-started), which means you
also need [**HHVM**](https://docs.hhvm.com/hhvm/installation/introduction). Once you have it installed, you have to
execute following command in project directory:

```
hh_client
```

# Usage

```
hhvm popstack.php [query]
```

For example:

```
$ hhvm popstack.php grep history
git grep <regexp> $(git rev-list --all)
```

# Technical details

Right now it's just a [popstack-php](https://github.com/rafalwrzeszcz/popstack/tree/popstack-php) adapted to run on
**HHVM**. Hopefully I'll have more time to play with **Hack**-specific features later.
