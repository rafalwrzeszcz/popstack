# PopStack

![](http://i.imgur.com/SZPjHwz.jpg)

## What is it?

It's the must-have tool for every developer. It allows you to copy-paste form [**StackOverflow**](stackoverflow.com)
just what is needed, without reading all those tons of descriptive explaination about roots of your problem - it just
gives you the answer you came there for! If you wanted to know why you have this strange `NullPointerException`, you
would read some documentation, run debugger - you just want it to work!

Just ask `popstack` your question and it will reply to you with a snippet that comes from an anwer that got accepted
on **StackOverflow**.

But seriously - what it does, it saves your time for performing common steps of:

- going to google,
- typing your query,
- picking first SO link,
- looking for accepted answer,
- picking code snippet from it.

It just prints it for you in the console.

You just do:

```
./popstack grep history
```

and it tells you what to do:

```
git grep <regexp> $(git rev-list --all)
```

Some other examples:

```
$ ./popstack hibernate manytomany
@ManyToMany(cascade = CascadeType.ALL)
@JoinTable(name = "SECRET_AGENT_MISSION", joinColumns = { @JoinColumn(name = "SecretAgentId") }, inverseJoinColumns =
{ @JoinColumn(name = "SecretMissionId") }
private List <Secret_Mission> missions = new ArrayList<Secret_Mission>();
```

```
$ ./popstack go map contains key
if val, ok := dict["foo"]; ok {
    //do something here
}
```

## Known issues (general, not implementation-dependent)

- **PopStack** uses for now (for simplicity) **StackOverflow** *similarity* searching, which only looks for matches in
titles. Hope to investigate API for a better call, or even use Google, but right now it may not always focus on best
match; also sometimes adding more keywords may result on less-matching result. For example `./popstack grep history` is
giving right now better match than `./popstach git grep hisotry`.

## What is it for me?

For me, personally, that was one big playground. In my spare time, when commuting back home by the train from Berlin
to Szczecin I had few evenings to spend on it. The (initial) solution is very trivial, so I decided to use it as an
excuse to work with some new stuff and gain some new skills.

# Implementation

Below is the list of the branches that are being currently active (you may check repository branches to see list of
historical implementations, that are not being updated anymore), just pick the one which suites you the best:

- [popstack-c++](https://github.com/rafalwrzeszcz/popstack/tree/popstack-c++) - C++ source - requires compilation on
it's own as well as building dependencies (also uses some Boost libraries);
- [popstack-csharp](https://github.com/rafalwrzeszcz/popstack/tree/popstack-csharp) - C# source - can be compiled with
Mono;
- [popstack-d](https://github.com/rafalwrzeszcz/popstack/tree/popstack-d) - D source - requires compilation, uses only
standard D library, no external dependencies;
- [popstack-hack](https://github.com/rafalwrzeszcz/popstack/tree/popstack-hack) - HHVM/Hack script - right now it's
just PHP source ensured to work under HHVM, plan to investigate more Hack features later;
- [popstack-java](https://github.com/rafalwrzeszcz/popstack/tree/popstack-java) - Java source code based on Unirest;
- [popstack-kotlin](https://github.com/rafalwrzeszcz/popstack/tree/popstack-kotlin) - Kotlin (another JVM-targetted)
implementation, using Fuel;
- [popstack-python](https://github.com/rafalwrzeszcz/popstack/tree/popstack-python) - Python script;
- [popstack-ruby](https://github.com/rafalwrzeszcz/popstack/tree/popstack-ruby) - Ruby script - another dependency-free
implementation based only on language's standard library;
- [popstack-rust](https://github.com/rafalwrzeszcz/popstack/tree/popstack-rust) - Rust source - requires compilation;
- [popstack-typescript](https://github.com/rafalwrzeszcz/popstack/tree/popstack-typescript) - Node.JS-targetted source
written in TypeScript (has only build dependencies, no runtime).

# Missing

After looking at the above list, you may think about at least few interesting, emerging, or even already having
established position on the market, platforms or languages that are missing. Why? Because of various reasons.

About some of them I might have not even hear about.

Some of them are not yet mature enought to make it fully working during a two-hours train ride (for example I tries to
use [**Julia**](http://julialang.org/) through **Docker**, but (even though it runs smootly and I used it already for
different purposes) it's image lacks tools required to build dependencies; I have great sentiment to **Pascal** and
love [**Free Pascal Compiler**](http://www.freepascal.org) for all of the great features they introduced into the
language, but it's just not fun anymore, but a very tedious work to build stuff working with modern solutions).

Some, like [**Haskell**](https://www.haskell.org) had no working libraries for the stuff I wanted to solve (I wasn't
going to develop HTTP client from scratch, just wanted to use existing blocks).

Some simply belong in the museum and should stay there!

I also didn't want to play with various **Node.JS** targets like **CoffeeScript**, **LiveScript** and others. In my
opinion they don't bring anything very usefull in general (just for particular cases) and makes it harder to experience
real **Node.JS** benefits. I've choosen [**TypeScript**](www.typescriptlang.org) as it's the only one major
compile-to-JS language that doesn't re-invent the wheel, but just adds (great!) features.

And some of them were simply abandoned. I'm not going to handle 30 branches all the time. It's just a play for me and
when it doesn't give me fun (satisfaction) it's not worth. Some languages simply don't fit this problem and some are
simply not funny at all (to me).
