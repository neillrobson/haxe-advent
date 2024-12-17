package y2024;

import DayEngine.TestData;
import util.HashSet;
import util.Vec2;

using StringTools;
using util.Tuple;

var testData = "
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732";

class Day10 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [36, 81]}];

        new Day10(data, tests, true);
    }

    function problem1(data:String):Dynamic {
        var map:Array<Array<Int>> = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0).map(s -> {
            var arr = [];
            for (i in 0...s.length)
                arr.push(Std.parseInt(s.charAt(i)));

            return arr;
        });

        var sum:Int = 0;

        for (i in 0...map.length)
            for (j in 0...map[0].length)
                if (map[i][j] == 0)
                    sum += scorePath(map, i, j);

        return sum;
    }

    function problem2(data:String):Dynamic {
        var map:Array<Array<Int>> = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0).map(s -> {
            var arr = [];
            for (i in 0...s.length)
                arr.push(Std.parseInt(s.charAt(i)));

            return arr;
        });

        var sum:Int = 0;

        for (i in 0...map.length)
            for (j in 0...map[0].length)
                if (map[i][j] == 0)
                    sum += countUniquePaths(map, i, j);

        return sum;
    }
}

function scorePath(data:Array<Array<Int>>, i:Int, j:Int) {
    var locs:HashSet<Vec2> = new HashSet();

    locs.set(new Vec2(j, i));

    for (n in 1...10) {
        if (locs.length == 0)
            return 0;

        var sources = locs.values();
        locs.clear();

        for (source in sources) {
            var x = source.x;
            var y = source.y;

            if (x - 1 >= 0 && data[y][x - 1] == n)
                locs.set(new Vec2(x - 1, y));
            if (y - 1 >= 0 && data[y - 1][x] == n)
                locs.set(new Vec2(x, y - 1));
            if (x + 1 < data[0].length && data[y][x + 1] == n)
                locs.set(new Vec2(x + 1, y));
            if (y + 1 < data.length && data[y + 1][x] == n)
                locs.set(new Vec2(x, y + 1));
        }
    }

    return locs.length;
}

function countUniquePaths(data:Array<Array<Int>>, i:Int, j:Int) {
    var c = data[i][j];

    if (c == 9)
        return 1;

    var sum = 0;
    var n = c + 1;

    if (j - 1 >= 0 && data[i][j - 1] == n)
        sum += countUniquePaths(data, i, j - 1);
    if (i - 1 >= 0 && data[i - 1][j] == n)
        sum += countUniquePaths(data, i - 1, j);
    if (j + 1 < data[0].length && data[i][j + 1] == n)
        sum += countUniquePaths(data, i, j + 1);
    if (i + 1 < data.length && data[i + 1][j] == n)
        sum += countUniquePaths(data, i + 1, j);

    return sum;
}
