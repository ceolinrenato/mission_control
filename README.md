
# MissionControl

This is a small proof of concept I've made to experience building CLI applications with Elixir. I've used the **Escript**, a builtin tool in mix to produce binary executable files that can be run on any system with Erlang installed, [check it out on Elixir School](https://elixirschool.com/en/lessons/advanced/escripts/).

As inspiration for the project this [programming challenge](challenge_specs.pdf) was used as an implementation goal for this CLI project.  

## Considerations

The programming challenge specs didn't say anything about probe collisions or probes going out of the land boundaries. But I've decided to implement these features, so whenever a probe tries to move out of the land limits or to a position another probe is located it will stay still.

**TO-DO**: at the moment two or more probes can still be initialized in the same coordinates, this should be validated also

## Installation

 1. Install Elixir and Erlang if you haven't already (this project includes a [.tool-versions](.tool-versions) file, so if you have [asdf](https://github.com/asdf-vm/asdf) you can just run asdf install in the root folder).
 2. Run `mix deps.get && mix escript.build`, this will get all dependencies and build the executable in the project's root directory

## Running the app

The app accepts a single or multiple files as input. The file contents must be like the below example, otherwise you would get an error:

```txt
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM

```

To run the application you must open a terminal session on the project's root directory and execute it like:

```bash
./mission_control path/to/file1 another/path/to/file2
```

## Running the tests

This is a mix project so to run the tests you can just execute in the terminal:

```bash
mix test
```

### Changelog

You can check this project changelog [here](CHANGELOG.md)
