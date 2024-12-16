package y2024;

import DayEngine.TestData;

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
        return 0;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}
