**Bash** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

It's just a **Bash** script, you can use it out of the box. However, you need to have [jshon](http://kmkeen.com/jshon/)
installed in your system (on **Debian**-based distributions `apt-get install jshon` does the job, probably on others
`yum` and other tools also know about this small tool).

If you want, you may copy this script to your `/usr/local/bin/` directory to make it globally available.

Other tools that are required: `sed` (I assume you have it), `gunzip` (should also be available nearly everywhere) and
`curl` (even if not installed, I'm pretty sure it's available in all major distributions).

# Usage

```
./popstack.sh [query]
```

For example:

```
$ ./popstack.sh grep history
git grep &lt;regexp&gt; $(git rev-list &lt;rev1&gt;..&lt;rev2&gt;)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet;
- sed prints LAST snippet, not first one - I made no research wheter it's of worse quality ;), but all other
implementations print FIRST one.
