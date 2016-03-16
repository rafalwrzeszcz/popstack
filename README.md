**Dart** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

Super simple - just install [**Dart** runtime](https://www.dartlang.org). That's all.

# Usage

```
dart popstack.dart [query]
```

For example:

```
$ dart popstack.dart grep history
git grep &lt;regexp&gt; $(git rev-list --all)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet;
- application doesn't exit after printing the response - probably client thread is still running.

