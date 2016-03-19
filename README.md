**Rust** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

You have to install [**Rust**](https://www.rust-lang.org/downloads.html) toolset in order to compile this project.

In project directory execute:

```
cargo build --release
```

Executable will be placed in `target/release/` directory.

# Usage

```
./popstack [query]
```

For example:

```
$ ./popstack grep history
git grep <regexp> $(git rev-list --all)
```
