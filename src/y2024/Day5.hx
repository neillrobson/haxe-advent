package y2024;

import DayEngine.TestData;

using Lambda;

var testData = '47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
';

class Day5 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [143, null] }
        ];

        new Day5(data, tests);
    }

    function problem1(data:String):Dynamic {
        var newlines = ~/\n\s*\n/g;
        var inputParts = newlines.split(data);
        var lookup = buildLookup(inputParts[0]);
        var lines = inputParts[1]
            .split("\n")
            .filter((line) -> line.length > 0)
            .map((line) -> {
                return line.split(",").map((i) -> Std.parseInt(i) ?? 0);
            });

        return lines.fold((line, sum) -> sum + checkLine(line, lookup), 0);
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

/**
 * 100x100 array. Row is the earlier page; column is the later page (true if entry exists)
 * @param data
 * @return Array<Array<Bool>>
 */
function buildLookup(data:String):Array<Array<Bool>> {
    var ret = [for (_ in 0...100) [for (_ in 0...100) false]];

    for (pair in data.split("\n")) {
        if (pair.length == 0) continue;

        var nums = pair.split("|").map((n) -> Std.parseInt(n) ?? 0);

        ret[nums[0]][nums[1]] = true;
    }

    return ret;
}

function checkLine(line:Array<Int>, lookup:Array<Array<Bool>>):Int {
    var prev:Array<Int> = [];

    for (i in line) {
        for (p in prev) {
            if (lookup[i][p]) return 0;
        }
        prev.push(i);
    }

    return line[Std.int(line.length / 2)];
}
