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

        new Day11(data, tests, true);
    }

    function problem1(data:String):Any {
        var map = data.split(' ').map(s -> s.trim()).filter(s -> s.length > 0).fold((s, map) -> {
            add(map, Int64.parseString(s), 1);

            return map;
        }, new Int64Map<Int64>());

        for (_ in 0...25)
            map = blink(map);

        var sum = 0i64;
        for (_ => v in map)
            sum += v;

        return sum.toStr();
    }

    function problem2(data:String):Any {
        var map = data.split(' ').map(s -> s.trim()).filter(s -> s.length > 0).fold((s, map) -> {
            add(map, Int64.parseString(s), 1);

            return map;
        }, new Int64Map<Int64>());

        for (_ in 0...75)
            map = blink(map);

        var sum = 0i64;
        for (_ => v in map)
            sum += v;

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

inline function add(map:Int64Map<Int64>, k:Int64, v:Int64) {
    map.set(k, (map.get(k) ?? 0i64) + v);
}

function blink(map:Int64Map<Int64>):Int64Map<Int64> {
    static var cache:Int64Map<{a:Int64, b:Int64}> = new Int64Map();

    var ret = new Int64Map<Int64>();

    var m:Int;

    for (k => v in map) {
        if (k == 0) {
            add(ret, 1, v);
        } else if ((m = mag(k)) % 2 == 0) {
            var ab = cache.get(k);

            if (ab == null) {
                var d = m >> 1;
                var a:Int64 = 0;
                var b:Int64 = 0;

                var digitArr:Array<Int64> = [];

                var z = k;
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
                cache.set(k, ab);
            }

            add(ret, ab.a, v);
            add(ret, ab.b, v);
        } else
            add(ret, k * 2024, v);
    }

    return ret;
}
