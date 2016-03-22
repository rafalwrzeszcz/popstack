**TypeScript** (**Node.JS**) implementation of [**PopStack**](https://github.com/rafalwrzeszcz/popstack).

# Installation

**TypeScript** is needed only for building the project, afterwards, it's a regular **Node.JS** application. And even
for building - everything is defined as **NPM** modules, so you just need to have `node` and `npm` installed in your
system (or just use [**Docker** image](https://hub.docker.com/_/node/).

To compile **TypeScript** into **JavaScript** just run:

```
npm run prepublish
```

# Usage

```
node src/popstack.js [query]
```

For example:

```
$ node src/popstack.js grep history
git grep <regexp> $(git rev-list --all)
```
