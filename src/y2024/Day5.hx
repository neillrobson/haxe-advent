package y2024;

import DayEngine.TestData;

using Lambda;

typedef Lookup = Array<Array<Bool>>;
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
var td2 = "2|4
4|5

1,4,3,5,2,8,9";

class Day5 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [143, 123]}, {data: td2, expected: [0, 4]}];

        new Day5(data, tests);
    }

    function problem1(data:String):Any {
        var newlines = ~/\n\s*\n/g;
        var inputParts = newlines.split(data);
        var lookup = buildLookup(inputParts[0]);
        var lines = inputParts[1].split("\n").filter((line) -> line.length > 0).map((line) -> {
            return line.split(",").map((i) -> Std.parseInt(i) ?? 0);
        });

        return lines.fold((line, sum) -> sum + checkLine(line, lookup), 0);
    }

    function problem2(data:String):Any {
        var newlines = ~/\n\s*\n/g;
        var inputParts = newlines.split(data);
        var lookup = buildLookup(inputParts[0]);
        var lines = inputParts[1].split("\n").filter((line) -> line.length > 0).map((line) -> {
            return line.split(",").map((i) -> Std.parseInt(i) ?? 0);
        });

        return lines.fold((line, sum) -> sum + fixLine(line, lookup), 0);
    }
}

/**
 * 100x100 array. Row is the earlier page; column is the later page (true if entry exists)
 * @param data
 * @return Lookup
 */
function buildLookup(data:String):Lookup {
    var ret = [for (_ in 0...100) [for (_ in 0...100) false]];

    for (pair in data.split("\n")) {
        if (pair.length == 0)
            continue;

        var nums = pair.split("|").map((n) -> Std.parseInt(n) ?? 0);

        ret[nums[0]][nums[1]] = true;
    }

    return ret;
}

function checkLine(line:Array<Int>, lookup:Lookup):Int {
    var prev:Array<Int> = [];

    for (i in line) {
        for (p in prev) {
            if (lookup[i][p])
                return 0;
        }
        prev.push(i);
    }

    return line[Std.int(line.length / 2)];
}

function fixLine(line:Array<Int>, lookup:Lookup):Int {
    var hasChange = false;

    for (i => n in line) {
        for (j in 0...i) {
            var p = line[j];

            if (lookup[n][p]) {
                hasChange = true;

                line[j] = n;
                line[i] = p;

                subcheck(line, lookup, j, i);

                n = p;
            }
        }
    }

    return hasChange ? line[Std.int(line.length / 2)] : 0;
}

function subcheck(line:Array<Int>, lookup:Lookup, s:Int, e:Int):Void {
    var p = line[s];

    for (i in s + 1...e) {
        var n = line[i];
        if (lookup[n][p]) {
            line[s] = n;
            line[i] = p;
            subcheck(line, lookup, s, i);
            s = i;
        }
    }
}
