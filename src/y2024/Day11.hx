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

        // sure(digitCount(0) == 1);
        // sure(digitCount(1) == 1);
        // sure(digitCount(9) == 1);
        // sure(digitCount(10) == 2);
        // sure(digitCount(99) == 2);
        // sure(digitCount(100) == 3);

        // sure(mag(0) == 1);
        sure(mag(1) == 1);
        sure(mag(9) == 1);
        sure(mag(10) == 2);
        sure(mag(99) == 2);
        sure(mag(100) == 3);

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

var powersOfTen = [
    0x1i64,
    0xAi64,
    0x64i64,
    0x3E8i64,
    0x2710i64,
    0x186A0i64,
    0xF4240i64,
    0x989680i64,
    0x5F5E100i64,
    0x3B9ACA00i64,
    0x2540BE400i64,
    0x174876E800i64,
    0xE8D4A51000i64,
    0x9184E72A000i64,
    0x5AF3107A4000i64,
    0x38D7EA4C68000i64,
    0x2386F26FC10000i64,
    0x16345785D8A0000i64,
    0xDE0B6B3A7640000i64,
    0x8AC7230489E80000i64,
    0xFFFFFFFFFFFFFFFFi64
];

inline function mag(n:Int64):Int {
    return powersOfTen.findIndex((i) -> i > n);
}

// var ln10 = Math.log(10);
// inline function digitCount(n:Int64):Int {
//     try {
//         var i = n.toInt();
//         return 1 + Math.floor(Math.max(Math.log(i), 0) / ln10);
//     } catch (e)
//         return n.toStr().length;
// }

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

        // var s = Std.string(n);
        // var d = s.length >> 1;
        // var a = Std.parseInt(s.substr(0, d));
        // var b = Std.parseInt(s.substr(d));

        return stoneCount(ab.a, i) + stoneCount(ab.b, i);
    } else
        return stoneCount(n * 2024, i);
}
