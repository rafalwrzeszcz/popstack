**C#** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

I only tested it with **Mono**!

You need **Mono** runtime and compiler installed together with some Mono libraries that are optional and not installed
by default (at least on **Debian**):

```
apt-get install mono-mcs libmono-system-numerics4.0-cil libmono-system-web4.0-cil libmono2.0-cil
```

You also need to download **JSON** library - don't worry there is a script for that (although you will need to copy DLL
to project root directory):

```
./build-json.net.sh
```

And then compile the project with the provided build script:

```
./build.sh
```

# Usage

```
mono popstack.exe [query]
```

For example:

```
$ mono popstack.exe grep history
git grep <regexp> $(git rev-list --all)
```
