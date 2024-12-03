package y2024;

import DayEngine.TestData;

var testData = '3   4
4   3
2   5
1   3
3   9
3   3
';

class Day1 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [11, null] }
        ];

        new Day1(data, tests);
    }

    function problem1(data:String):Dynamic {
        var first:Array<Int> = [];
        var second:Array<Int> = [];

        for (line in data.split("\n")) {
            var parts = line.split("   ");
            if (parts.length != 2) {
                continue;
            }
            first.push(Std.parseInt(parts[0]));
            second.push(Std.parseInt(parts[1]));
        }

        first.sort((a, b) -> a - b);
        second.sort((a, b) -> a - b);

        var result = 0;
        for (i in 0...first.length) {
            result += Math.floor(Math.abs(first[i] - second[i]));
        }

        return result;
    }

    function problem2(data:String):Dynamic {
        return data.split("\n").length;
    }
}
