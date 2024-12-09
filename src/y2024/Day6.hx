package y2024;

import DayEngine.TestData;

using StringTools;

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

enum Dir {
    UP;
    RIGHT;
    DOWN;
    LEFT;
}

class Day6 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [41, 6] }
        ];

        new Day6(data, tests);
    }

    function problem1(data:String):Dynamic {
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

    function problem2(data:String):Dynamic {
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
                        y = newY;
                        if (checkLoop(map, dir, y, x)) Sys.println(count++);
                    }
                case Dir.RIGHT:
                    var newX = x + 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.DOWN;
                    else {
                        x = newX;
                        if (checkLoop(map, dir, y, x)) Sys.println(count++);
                    }
                case Dir.DOWN:
                    var newY = y + 1;
                    if (newY < 0 || newY >= map.length)
                        break;
                    if (map[newY][x] < 0)
                        dir = Dir.LEFT;
                    else {
                        y = newY;
                        if (checkLoop(map, dir, y, x)) Sys.println(count++);
                    }
                case Dir.LEFT:
                    var newX = x - 1;
                    if (newX < 0 || newX >= map[0].length)
                        break;
                    if (map[y][newX] < 0)
                        dir = Dir.UP;
                    else {
                        x = newX;
                        if (checkLoop(map, dir, y, x)) Sys.println(count++);
                    }
            }
        }

        return count;
    }
}

function checkLoop(map:Array<Array<Int>>, iDir:Dir, iy:Int, ix:Int):Bool {
    var bx = ix;
    var by = iy;
    switch (iDir) {
        case Dir.UP:
            by--;
        case Dir.RIGHT:
            bx++;
        case Dir.DOWN:
            by++;
        case Dir.LEFT:
            bx--;
    }

    var x = ix;
    var y = iy;
    var dir = iDir;

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
                    if (y == iy && x == ix && dir == iDir) return true;
                }
            case Dir.RIGHT:
                var newX = x + 1;
                if (newX < 0 || newX >= map[0].length)
                    break;
                if (map[y][newX] < 0 || y == by && newX == bx)
                    dir = Dir.DOWN;
                else {
                    x = newX;
                    if (y == iy && x == ix && dir == iDir) return true;
                }
            case Dir.DOWN:
                var newY = y + 1;
                if (newY < 0 || newY >= map.length)
                    break;
                if (map[newY][x] < 0 || newY == by && x == bx)
                    dir = Dir.LEFT;
                else {
                    y = newY;
                    if (y == iy && x == ix && dir == iDir) return true;
                }
            case Dir.LEFT:
                var newX = x - 1;
                if (newX < 0 || newX >= map[0].length)
                    break;
                if (map[y][newX] < 0 || y == by && newX == bx)
                    dir = Dir.UP;
                else {
                    x = newX;
                    if (y == iy && x == ix && dir == iDir) return true;
                }
        }
    }

    return false;
}
