package y2024;

import DayEngine.TestData;
import Sure.sure;
import util.Int64Map;

using Lambda;
using StringTools;
using haxe.Int64;

var testData = "125 17";

class Day11 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: ["55312"]}];

        sure(mag(0) == 1);
        sure(mag(1) == 1);
        sure(mag(9) == 1);
        sure(mag(10) == 2);
        sure(mag(99) == 2);
        sure(mag(100) == 3);
        sure(mag(100000000000000000i64) == 18);
        sure(mag(1000000000000000000i64) == -1);

        var testMap = new Int64Map<Int>();
        testMap.set(123, 45);
        testMap.set(1000000000000000i64, 78);

        for (k => v in testMap)
            Sys.println('${k.toStr()}: $v');

        new Day11(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        var ints:Array<Int64> = data.split(' ').map(s -> s.trim()).filter(s -> s.length > 0).map(Int64.parseString);

        var sum:Int64 = ints.fold((i, acc) -> acc + stoneCount(i, 25), 0);

        return sum.toStr();
    }

    function problem2(data:String):Dynamic {
        var ints:Array<Int64> = data.split(' ').map(s -> s.trim()).filter(s -> s.length > 0).map(Int64.parseString);

        var sum:Int64 = ints.fold((i, acc) -> acc + stoneCount(i, 75), 0);

        return sum.toStr();
    }
}

var powersOfTen = [
    0i64,
    10i64,
    100i64,
    1000i64,
    10000i64,
    100000i64,
    1000000i64,
    10000000i64,
    100000000i64,
    1000000000i64,
    10000000000i64,
    100000000000i64,
    1000000000000i64,
    10000000000000i64,
    100000000000000i64,
    1000000000000000i64,
    10000000000000000i64,
    100000000000000000i64,
    1000000000000000000i64
];

inline function mag(n:Int64):Int {
    return powersOfTen.findIndex((i) -> i > n);
}

function stoneCount(n:Int64, i:Int):Int64 {
    static var cache:Int64Map<{a:Int64, b:Int64}> = new Int64Map();

    if (i == 0)
        return 1;

    --i;

    var m:Int;

    if (n == 0)
        return stoneCount(1, i);
    else if ((m = mag(n)) % 2 == 0) {
        var ab = cache.get(n);

        if (ab == null) {
            var d = m >> 1;
            var a:Int64 = 0;
            var b:Int64 = 0;

            var digitArr:Array<Int64> = [];

            var z = n;
            while (z > 0) {
                var qm = z.divMod(10);
                digitArr.push(qm.modulus);
                z = qm.quotient;
            }

            for (j in 1...d + 1) {
                a = a * 10 + digitArr[m - j];
                b = b * 10 + digitArr[m - j - d];
            }

            ab = {a: a, b: b};
            cache.set(n, ab);
        }

        return stoneCount(ab.a, i) + stoneCount(ab.b, i);
    } else
        return stoneCount(n * 2024, i);
}
