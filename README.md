# Haxe Advent

> Learning Haxe through Advent of Code challenges.

## Setup

* Put AoC data into a file named `/cache/2024/[day].txt`. Day is 1-25 for December first through twenty-fifth.
* From the root directory, run:

```
haxe build.hxml
```

By default, the current day will run. You can change the argument to `new Main(x)` in `Main.hx` to override that behavior.

If you run the program on a day outside 1-25, or when the corresponding Haxe day-class doesn't exist, things will probably crash.
