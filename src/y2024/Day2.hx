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

/**
    Single zero: acceptable
    Multiple zeroes, whether consecutive or not: unacceptable
    Single sign flip: add to next number. Only accept if result is matching sign.

    Maybe "add to next number" is the way to go for all of these??? Then "check two"
**/

function checkThree(data:Array<Int>, sig:Int = 0):Bool {
    if (data.length < 3) {
        return sig == 0 ? checkTwo(data, sig) : true;
    }

    var first = data[0];
    var second = data[1];
    var third = data[2];

    var sig1 = signum(first, second);
    var sig2 = signum(second, third);

    var diff1 = Math.abs(first - second);
    var diff2 = Math.abs(second - third);

    if (sig == 0) {
        if (sig1 == sig2) {
            sig = sig1;
        } else {
            var copy = data.copy();
            copy.shift();
            data.splice(1, 1);

            return checkTwo(copy) || checkTwo(data);
        }

        if (diff1 < 1 || diff1 > 3 || diff2 < 1 || diff2 > 3) {
            var copy = data.copy();
            copy.shift();
            data.splice(1, 1);

            return checkTwo(copy) || checkTwo(data);
        }
    } else {
        if (sig2 != sig || diff2 < 1 || diff2 > 3) {
            var copy = data.copy();
            data.splice(1, 1);
            copy.splice(2, 1);

            return checkTwo(data, sig) || checkTwo(copy, sig);
        }
    }

    var copy = data.copy();
    copy.shift();

    return checkThree(copy, sig);
}

function checkTwo(data:Array<Int>, sig:Int = 0):Bool {
    if (data.length < 2) {
        return true;
    }

    var first = data[0];
    var second = data[1];

    if (sig == 0) {
        sig = signum(first, second);
    } else if (signum(first, second) != sig) {
        return false;
    }

    var diff = Math.abs(first - second);
    if (diff < 1 || diff > 3) {
        return false;
    }

    var copy = data.copy();
    copy.shift();

    return checkTwo(copy, sig);
}

class Day2 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [2, 4] },
            { data: '7 8 6 5 4', expected: [0, 1]},
            { data: '6 8 6 5 4', expected: [0, 1]},
            { data: '8 7 6 5 6', expected: [0, 1]},
            { data: '7 6 5 6 4', expected: [0, 1]},

            { data: '8 7 4 7 5', expected: [0, 0]},
            { data: '8 7 4 7 3', expected: [0, 1]},
            { data: '8 7 4 6 5', expected: [0, 1]},
            { data: '8 7 4 6 3', expected: [0, 1]},

            { data: '4 5 7 10 9', expected: [0, 1]},
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

            if (checkTwo(ints)) {
                validCount++;
            }
        }

        return validCount;
    }

    function problem2(data:String):Dynamic {
        var validCount = 0;

        for (line in data.split("\n")) {
            if (line.length == 0) {
                continue;
            }

            var ints = line.split(" ").map(Std.parseInt);

            if (checkThree(ints)) {
                validCount++;
            } else {
                trace(ints);
            }
        }

        return validCount;
    }
}
