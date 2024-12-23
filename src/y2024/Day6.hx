package y2024;

import DayEngine.TestData;

using StringTools;

// too high: 1877, 1798

var testData = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
";
var test2 = "
.......#.......
.#..........#..
........#...#..
#.............#
.......^...#...
.....#.......#.
.......#.......
....#..........
......#........
";

enum Dir {
    UP;
    RIGHT;
    DOWN;
    LEFT;
}

class Day6 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [41, 6]}, {data: test2, expected: [null, 6]},];

        new Day6(data, tests, true);
    }

    function problem1(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length != 0);
        var map:Array<Array<Int>> = [];
        var x:Int = -1, y:Int = -1;

        for (i => line in lines) {
            var lineArr = [];

            for (j in 0...line.length) {
                var c = line.charAt(j);
                lineArr.push(c == "#" ? -1 : 0);
                if (c == "^") {
                    x = j;
                    y = i;
                    lineArr[j] = 1;
                }
            }

            map.push(lineArr);
        }

        if (x < 0 || y < 0) {
            Sys.println("Initial location not found");
            return null;
        }

        var count = 1;
        var dir = Dir.UP;

        while (true) {
            switch (dir) {
                case Dir.UP:
                    var newY = y - 1;
                    if (newY < 0 || newY >= map.length)
                        break;
                    if (map[newY][x] < 0)
                        dir = Dir.RIGHT;
                    else {
                        y = newY;
                        if (map[y][x] == 0) {
                            map[y][x] = 1;
                            ++count;
                        }
                    }
                case Dir.RIGHT:
                    var newX = x + 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.DOWN;
                    else {
                        x = newX;
                        if (map[y][x] == 0) {
                            map[y][x] = 1;
                            ++count;
                        }
                    }
                case Dir.DOWN:
                    var newY = y + 1;
                    if (newY < 0 || newY >= map.length)
                        break;
                    if (map[newY][x] < 0)
                        dir = Dir.LEFT;
                    else {
                        y = newY;
                        if (map[y][x] == 0) {
                            map[y][x] = 1;
                            ++count;
                        }
                    }
                case Dir.LEFT:
                    var newX = x - 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.UP;
                    else {
                        x = newX;
                        if (map[y][x] == 0) {
                            map[y][x] = 1;
                            ++count;
                        }
                    }
            }
        }

        return count;
    }

    function problem2(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length != 0);
        var map:Array<Array<Int>> = [];
        var x:Int = -1, y:Int = -1;

        for (i => line in lines) {
            var lineArr = [];

            for (j in 0...line.length) {
                var c = line.charAt(j);
                lineArr.push(c == "#" ? -1 : 0);
                if (c == "^") {
                    x = j;
                    y = i;
                    lineArr[j] = 1;
                }
            }

            map.push(lineArr);
        }

        var blocks:Array<Array<Int>> = [for (i in 0...map.length) map[i].copy()];
        blocks[y][x] = 0;

        if (x < 0 || y < 0) {
            Sys.println("Initial location not found");
            return null;
        }

        var count = 0;
        var dir = Dir.UP;

        while (true) {
            switch (dir) {
                case Dir.UP:
                    var newY = y - 1;
                    if (newY < 0 || newY >= map.length)
                        break;
                    if (map[newY][x] < 0)
                        dir = Dir.RIGHT;
                    else {
                        if (checkLoop(map, dir, y, x)) {
                            if (blocks[newY][x]++ < 1)
                                count++;
                        }
                        y = newY;
                        map[y][x] |= 1;
                    }
                case Dir.RIGHT:
                    var newX = x + 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.DOWN;
                    else {
                        if (checkLoop(map, dir, y, x)) {
                            if (blocks[y][newX]++ < 1)
                                count++;
                        }
                        x = newX;
                        map[y][x] |= 2;
                    }
                case Dir.DOWN:
                    var newY = y + 1;
                    if (newY < 0 || newY >= map.length)
                        break;
                    if (map[newY][x] < 0)
                        dir = Dir.LEFT;
                    else {
                        if (checkLoop(map, dir, y, x)) {
                            if (blocks[newY][x]++ < 1)
                                count++;
                        }
                        y = newY;
                        map[y][x] |= 4;
                    }
                case Dir.LEFT:
                    var newX = x - 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.UP;
                    else {
                        if (checkLoop(map, dir, y, x)) {
                            if (blocks[y][newX]++ < 1)
                                count++;
                        }
                        x = newX;
                        map[y][x] |= 8;
                    }
            }
        }

        return count;
    }
}

function checkLoop(map:Array<Array<Int>>, dir:Dir, y:Int, x:Int):Bool {
    var dirs:Array<Array<Int>> = [for (i in 0...map.length) map[i].copy()];

    var bx = x;
    var by = y;
    switch (dir) {
        case Dir.UP:
            by--;
            dirs[y][x] |= 1;
        case Dir.RIGHT:
            bx++;
            dirs[y][x] |= 2;
        case Dir.DOWN:
            by++;
            dirs[y][x] |= 4;
        case Dir.LEFT:
            bx--;
            dirs[y][x] |= 8;
    }

    // We can't put a barrier here because the guard's path previously went through here
    if (dirs[by][bx] != 0)
        return false;

    while (true) {
        switch (dir) {
            case Dir.UP:
                var newY = y - 1;
                if (newY < 0 || newY >= map.length)
                    break;
                if (map[newY][x] < 0 || newY == by && x == bx)
                    dir = Dir.RIGHT;
                else {
                    y = newY;
                    if (dirs[y][x] & 1 > 0)
                        return true;
                    dirs[y][x] |= 1;
                }
            case Dir.RIGHT:
                var newX = x + 1;
                if (newX < 0 || newX >= map[0].length)
                    break;
                if (map[y][newX] < 0 || y == by && newX == bx)
                    dir = Dir.DOWN;
                else {
                    x = newX;
                    if (dirs[y][x] & 2 > 0)
                        return true;
                    dirs[y][x] |= 2;
                }
            case Dir.DOWN:
                var newY = y + 1;
                if (newY < 0 || newY >= map.length)
                    break;
                if (map[newY][x] < 0 || newY == by && x == bx)
                    dir = Dir.LEFT;
                else {
                    y = newY;
                    if (dirs[y][x] & 4 > 0)
                        return true;
                    dirs[y][x] |= 4;
                }
            case Dir.LEFT:
                var newX = x - 1;
                if (newX < 0 || newX >= map[0].length)
                    break;
                if (map[y][newX] < 0 || y == by && newX == bx)
                    dir = Dir.UP;
                else {
                    x = newX;
                    if (dirs[y][x] & 8 > 0)
                        return true;
                    dirs[y][x] |= 8;
                }
        }
    }

    return false;
}
