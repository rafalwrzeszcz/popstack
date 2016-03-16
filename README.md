**PHP** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

This project is built for **PHP7**.

You can use [**DotDeb** repository](https://www.dotdeb.org/) or simply use
[**Docker** image](https://hub.docker.com/_/php/).

# Usage

```
php popstack.php [query]
```

For example:

```
$ php popstack.php grep history
git grep <regexp> $(git rev-list --all)
```

**Note:** Make sure `php` resolves to version 7 - if your default **PHP** version is 5 (or, for god's sake, 4? 3?!),
then use `php7` to explicitly run version 7.
