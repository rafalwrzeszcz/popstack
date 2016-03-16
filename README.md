**Kotlin** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

All you need is just **JDK** installation and **Maven** (I recommend using just
[**Docker** image](https://hub.docker.com/_/maven/). All **Kotlin**-related things, like compiler and standard library
are defined as project dependencies and they will be automatically downloaded during project build.

And to build the project simply execute:

```
mvn install
```

# Usage

```
java -cp $CLASSPATH popstack.PopstackTk [query]
```

You can check `popstack` shell script about what needs to be placed on classpath. It will be easier in future, but I
didn't want to spend time creating manifest file for `.jar`. But still, it's possible to run project directly through
**Maven**, for example:

```
$ mvn -q exec:java -Dexec.mainClass=popstack.PopstackKt -Dexec.arguments="grep history"
git grep &lt;regexp&gt; $(git rev-list --all)
```

# Known issues

- response is presented in it's plain HTML form, which means HTML entities may bloat the snippet.
