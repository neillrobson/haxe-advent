package y2024;

import DayEngine.TestData;
import Sure.sure;

using Lambda;
using StringTools;
using haxe.Int64;

var testData = "125 17";

// 147245 too low

class Day11 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: ["55312"]}];

        sure(digitCount(0) == 1);
        sure(digitCount(1) == 1);
        sure(digitCount(9) == 1);
        sure(digitCount(10) == 2);
        sure(digitCount(99) == 2);
        sure(digitCount(100) == 3);

        new Day11(data, tests, true);
    }

    function problem1(data:String):Dynamic {
        var ints:Array<Int64> = data.split(' ').map(s -> s.trim()).filter(s -> s.length > 0).map(Int64.parseString);

        var sum:Int64 = ints.fold((i, acc) -> acc + stoneCount(i, 25), 0);

        return sum.toStr();
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

var ln10 = Math.log(10);

inline function digitCount(n:Int64):Int {
    try {
        var i = n.toInt();

        return 1 + Math.floor(Math.max(Math.log(i), 0) / ln10);
    } catch (e)
        return n.toStr().length;
}

function stoneCount(n:Int64, i:Int):Int64 {
    if (i == 0)
        return 1;

    --i;

    if (n == 0)
        return stoneCount(1, i);
    else if (digitCount(n) % 2 == 0) {
        var s = Std.string(n);
        var d = s.length >> 1;
        var a = Std.parseInt(s.substr(0, d));
        var b = Std.parseInt(s.substr(d));

        return stoneCount(a, i) + stoneCount(b, i);
    } else
        return stoneCount(n * 2024, i);
}
