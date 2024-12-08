# Haxe Advent

> Learning Haxe through Advent of Code challenges.

## Setup

* Put AoC data into a file named `/cache/2024/[day].txt`. Day is 1-25 for December first through twenty-fifth.
* If you prefer automatic fetching, put your user agent and session cookie value into the following _single-line_ files:
  * `secrets/useragent`
  * `secrets/session`
* From the root directory, run:

```
haxe build.hxml [day]
```

By default, the current day will run. You can change the `[day]` argument on the command line to override.

If you run the program on a day outside 1-25, or when the corresponding Haxe day-class doesn't exist, things will probably crash.
