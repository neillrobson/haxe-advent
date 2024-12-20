package y2024;

import DayEngine.TestData;

var testData = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3";

class Day14 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [12]}];

        new Day14(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}
