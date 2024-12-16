package y2024;

import DayEngine.TestData;
import util.HashSet;
import util.Vec2;

using StringTools;
using util.Tuple;

var testData = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732";

class Day10 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [36]}];

        new Day10(data, tests, false);
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
        return null;
    }
}

function scorePath(data:Array<Array<Int>>, i:Int, j:Int) {
    var locs:HashSet<Vec2> = new HashSet();

    return 0;
}
