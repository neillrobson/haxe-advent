package y2024;

import DayEngine.TestData;

using Lambda;

var testData = '7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
';

function signum(a:Int):Int {
    if (a == 0) {
        return 0;
    }

    return a < 0 ? -1 : 1;
}

function checkPairs(data:Array<Int>):Bool {
    var signa = data.map(signum);
    if (signa.exists((i) -> i != signa[0])) return false;

    var mags = data.map(Math.abs);
    if (mags.exists((i) -> i < 1 || i > 3)) return false;

    return true;
}

function scanStrict(data:Array<Int>):Bool {
    if (data.length < 2) {
        return true;
    }

    var pairs = [for (i in 1...data.length) data[i] - data[i-1]];

    return checkPairs(pairs);
}

function scanTolerant(data:Array<Int>):Bool {
    if (data.length < 2) {
        return true;
    }

    var pairs = [for (i in 1...data.length) data[i] - data[i-1]];

    // We should never see "zero" here, because of the magnitude requirement
    var sigIndexes = [
        -1 => -1,
        1 => -1
    ];
    var mainSig:Null<Int> = null;
    var outlierIdx = -1;

    for (i => v in pairs) {
        var mag = Math.abs(v);
        if (mag < 1 || mag > 3) {
            outlierIdx = i;
            break;
        }

        var sig = signum(v);
        if (mainSig == null && sigIndexes[sig] >= 0) {
            mainSig = sig;
            outlierIdx = sigIndexes[-sig];
            if (outlierIdx >= 0) break;
        }
        if (mainSig != null && mainSig != sig) {
            outlierIdx = i;
            break;
        }
        sigIndexes[sig] = i;
    }

    if (outlierIdx < 0) return true;

    var ret = false;

    if (outlierIdx > 0) {
        var check = pairs[outlierIdx - 1] + pairs[outlierIdx];

        var copy = pairs.copy();
        copy.splice(outlierIdx, 1);
        copy[outlierIdx - 1] = check;
        ret = ret || checkPairs(copy);
    } else {
        var copy = pairs.copy();
        copy.shift();
        ret = ret || checkPairs(copy);
    }

    if (outlierIdx < pairs.length - 1) {
        var check = pairs[outlierIdx] + pairs[outlierIdx + 1];

        var copy = pairs.copy();
        copy.splice(outlierIdx, 1);
        copy[outlierIdx] = check;
        ret = ret || checkPairs(copy);
    } else {
        var copy = pairs.copy();
        copy.pop();
        ret = ret || checkPairs(copy);
    }

    return ret;
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
            { data: '3 4 5 10 7', expected: [0, 1]},

            { data: '50 48 48 46 44', expected: [0, 1]},
            { data: '58 57 58 56 54', expected: [0, 1]},
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

            if (scanStrict(ints)) {
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

            if (scanTolerant(ints)) {
                validCount++;
            }
        }

        return validCount;
    }
}
