package y2024;

import DayEngine.TestData;

using Lambda;
using StringTools;
using haxe.Int64;

var testData = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
";

class Day7 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: ["3749", null] }
        ];

        new Day7(data, tests, true);
    }

    function problem1(data:String):Dynamic {
        var result = data
            .split("\n")
            .map(s -> s.trim())
            .filter(s -> s.length > 0)
            .fold((s, sum) -> {
                var data = s.split(':');
                var goal = Int64.parseString(data[0]);
                var nums = data[1].trim().split(' ').map(Int64.parseString);

                if (checkLine(goal, nums)) sum += goal;

                return sum;
            }, 0);

        return result.toStr();
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

function checkLine(goal:Int64, nums:Array<Int64>):Bool {
    return checkRecurse(goal, nums, 1, false, nums[0]) || checkRecurse(goal, nums, 1, true, nums[0]);
}

function checkRecurse(goal:Int64, nums:Array<Int64>, i:Int, op:Bool, acc:Int64) {
    if (i == nums.length) return goal == acc;

    if (op) acc *= nums[i];
    else acc += nums[i];

    return checkRecurse(goal, nums, i+1, false, acc) || checkRecurse(goal, nums, i+1, true, acc);
}
