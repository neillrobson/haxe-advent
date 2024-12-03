package y2024;

import DayEngine.TestData;

using Lambda;

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
            { data: testData, expected: [11, 31] }
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
        var firstList:Array<Int> = [];
        var secondMap = new Map<Int, Int>();

        for (line in data.split("\n")) {
            var parts = line.split("   ");
            if (parts.length != 2) {
                continue;
            }
            var first = Std.parseInt(parts[0]);
            var second = Std.parseInt(parts[1]);

            firstList.push(first);
            if (secondMap[second] == null) {
                secondMap[second] = 1;
            } else {
                secondMap[second]++;
            }
        }

        return firstList.map((first) -> first * (secondMap[first] ?? 0)).fold((a, b) -> a + b, 0);
    }
}
