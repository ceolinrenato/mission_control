
# MissionControl

  

This is a small proof of concept I've made to experience building CLI applications with Elixir. I've used the **Escript**, a builtin tool in mix to produce binary executables that can be run on any system with Erlang installed, [check it out on Elixir School](https://elixirschool.com/en/lessons/advanced/escripts/).

As inspiration for the project this [programming chalenge](challenge_specs.pdf) was used as an implementation goal for this CLI project.  

## Installation

 1. Install Elixir and Erlang if you haven't already (this project includes a [.tool-versions](.tool_versions) file, so if you have [asdf](https://github.com/asdf-vm/asdf) you can just run asdf install in the root folder).
 2. Run `mix deps.get && mix escript.build`, this will get all dependencies and build the executable in the project's root directory

## Running the app

The app accepts a single or multiple files as input. The file contents must be like the below example, otherwise you would get an error:

```
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM

```

To run the application you must open a terminal session on the project's root directory and execute it like:

    ./mission_control path/to/file1 another/path/to/file2

## Running the tests

This is a mix project so to run the tests you can just execute in the terminal:

    mix test

