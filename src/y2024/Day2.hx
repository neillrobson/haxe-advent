package y2024;

import DayEngine.TestData;

var testData = '7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
';

function signum(a:Int, b:Int):Int {
    if (a == b) {
        return 0;
    }

    return a < b ? -1 : 1;
}

class Day2 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [2, null] }
        ];

        new Day2(data, tests);
    }

    function problem1(data:String):Dynamic {
        var validCount = 0;

        for (line in data.split("\n")) {
            if (line.length == 0) {
                continue;
            }

            var ints = line.split(" ").map(Std.parseInt);

            var cmp = signum(ints[0], ints[1]);
            var valid = true;
            for (i in 0...ints.length - 1) {
                var a = ints[i];
                var b = ints[i + 1];

                if (signum(a, b) != cmp) {
                    valid = false;
                    break;
                }

                var diff = Math.abs(a - b);
                if (diff < 1 || diff > 3) {
                    valid = false;
                    break;
                }
            }

            if (valid) {
                validCount++;
            }
        }

        return validCount;
    }

    function problem2(data:String):Dynamic {
        return 0;
    }
}
