**Python** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

This project is built for **Python 3**! I use **Python 3.4**.

It's usually available in most distributions, however often version installed by default is still **Python 2.x**. Make
sure you have version 3 installed - for example via `apt-get install python3`.

You also need to install `requests` package in your system:

```
pip install requests
```

# Usage

```
python popstack.py [query]
```

For example:

```
$ python popstack.py grep history
git grep <regexp> $(git rev-list --all)
```

**Note:** Make sure `python` resolves to version 3 - if your default **Python** version is 2, then use `python3` to
explicitly run version 3.
