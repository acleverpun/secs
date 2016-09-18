# Secs

## SECS Entity Component System

An ECS for LÖVE, built in [moonscript](http://moonscript.org/).

Probably works in native lua, too, but I have not yet tested it.

## Background

I actually think moonscript looks quite ugly...
I was never a fan of its inspirations, coffeescript and ruby.
To be fair, many of its ugly parts are opt-in (like optional parens for function calls. I _always_ use parens!).
Despite the ugliness, moonscript adds many great things to lua and as such is worth using in my opinion.
Its class implementation is one of those gems---I honestly feel like moonscript's classes are the best in the entire lua ecosystem, and one of the many things that I very much enjoy working with.

In making a LÖVE project (found [here](https://github.com/acleverpun/oneofthesedays)), I wanted a way to use libraries that are built on top of Middleclass, without actually using Middleclass.
I posted about my struggle [here](https://www.reddit.com/r/moonscript/comments/4xc0sf/interoperability_with_middleclass/), and of course since this is way over the heads of most people that use LÖVE, nobody cared.
I was able to use my solution to extend [lovetoys](https://github.com/lovetoys/lovetoys) classes.

Ultimately, I started getting frustrated with lovetoys.
I have made quite a few pull requests, but kept getting mad because I found the library was more and more broken as I did more with it.
After I found [a completely library-breaking bug](https://github.com/lovetoys/lovetoys/issues/60) so bad that I really don't understand how anyone has been using the library at all over the past few years, I decided to make my own ECS.
In doing so, I stopped using my creative middleclass-proxy solution, but took the mains parts with me into [my own class library](https://github.com/acleverpun/caste).
Thus this should actually be compatible with middleclass, though to what extent I can no longer say.

## Install

Just add as a submodule to your project:

```bash
git submodule add https://github.com/acleverpun/secs.git vendor/secs
git submodule update --init --remote --recursive
```

## Build

This project uses the `make` build automation tool.
All build targets can be found in the `makefile`, and all scripts in the `./scripts` directory.

```bash
# build project
make
# or
make build

# clean dist files
make clean

# watch filesystem and build when changes are made
make watch

# run linter on project
make lint
```

## Contributing

Please feel free to contribute.
Also feel free to open issues, ask questions, make suggestions, etc.
