**Elixir** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You need to have [**Elixir**](http://elixir-lang.org) installed as well as [**Erlang** Beam VM](http://erlang.org),
but since **Elixir** depends on **Erlang**, installing first one in package manager will probably bring the second one
together.

Project is managed with **Mix**, so you can compile it just wiht:

```
mix compile
```

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep &lt;regexp&gt; $(git rev-list --all)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet.

