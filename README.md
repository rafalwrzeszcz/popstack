**Ceylon** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

Project is marked as only native for **JVM**.

All you need to run it is to have [**Ceylon**](http://ceylon-lang.org/download) installed in your system (it depends on
JVM anyway).

After just, just build the project with:

```
ceylon compile
```

# Usage

```
ceylon run popstack [query]
```

For example:

```
$ ceylon run popstack grep history
git grep &lt;regexp&gt; $(git rev-list --all)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet;
- application doesn't exit after printing the response - probably Vert.x thread is still running.

# Technical details

Project is based on version `1.2.0` of **Ceylon** as **Vert.x** was not updated to work with the latest releases and
`1.2.1` is not backward compatible (great sem-ver ;)).
