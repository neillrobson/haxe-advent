package y2024;

import DayEngine.TestData;
import VectorMath.vec2;

using StringTools;



var testData = "
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
";

class Day8 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [14] }
        ];

        new Day8(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        var parsed:Array<String> = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);
        var length = parsed.length;
        var width = parsed[0].length;

        var map:Map<String, Bool> = [];

        map.set(vec2(5, 3).toString(), false);
        map.set(vec2(0, 0).toString(), true);
        map.set(vec2(5, 3).toString(), true);

        for (key in map.keys()) Sys.println(key.toString());

        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}
