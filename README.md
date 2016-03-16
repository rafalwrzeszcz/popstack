**Java** implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

All you need is just **JDK** installation and **Maven** (I recommend using just
[**Docker** image](https://hub.docker.com/_/maven/).

To build the project simply execute:

```
mvn install
```

# Usage

```
java -cp $CLASSPATH popstack.Popstack [query]
```

You can check `popstack` shell script about what needs to be placed on classpath. It will be easier in future, but I
didn't want to spend time creating manifest file for `.jar`. But still, it's possible to run project directly through
**Maven**, for example:

```
$ mvn -q exec:java -Dexec.mainClass=popstack.Popstack -Dexec.arguments="grep history"
git grep <regexp> $(git rev-list --all)
```
