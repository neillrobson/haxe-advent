package y2024;

import DayEngine.TestData;

var testData = "Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279";

class Day13 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [480]}];

        new Day13(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}
