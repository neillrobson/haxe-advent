package y2024;

import DayEngine.TestData;
import Sure.sure;
import haxe.ds.Vector;
import util.Vec2;

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

        var inconsistent = Vector.fromArrayCopy([
            Vector.fromArrayCopy([1., -2, 3, 2]),
            Vector.fromArrayCopy([2., -3, 8, 7]),
            Vector.fromArrayCopy([3., -4, 13, 8]),
        ]);

        var earlyBreak = Vector.fromArrayCopy([
            Vector.fromArrayCopy([1., -2, 3, 2]),
            Vector.fromArrayCopy([2., -4, 7, 7]),
            Vector.fromArrayCopy([3., -6, 13, 8]),
        ]);

        for (v in earlyBreak)
            Sys.println(v);
        sure(gaussJordan(earlyBreak) == 1);
        for (v in earlyBreak)
            Sys.println(v);

        var ret = diophantine(258, 147, 369);
        sure(ret.v.x == 492);
        sure(ret.v.y == -861);
        sure(ret.r == 3);

        ret = diophantine(147, 258, 369);
        sure(ret.v.y == 492);
        sure(ret.v.x == -861);
        sure(ret.r == 3);

        new Day13(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

function gaussJordan(a:Vector<Vector<Float>>):Int {
    var n = a.length;
    var flag = -1;

    for (i in 0...n) {
        // If the diagonal entry is zero,
        // find the next non-zero entry for that column
        // and switch the two rows.
        if (a[i][i] == 0) {
            var c = 1;
            while ((i + c) < n && a[i + c][i] == 0)
                ++c;
            if ((i + c) == n) {
                // Keep track of a "bad" row,
                // but continue processing so that
                // the bad row will be zeroed out.
                flag = i;
                continue;
            }
            for (k in 0...n + 1) {
                var temp = a[i][k];
                a[i][k] = a[i + c][k];
                a[i + c][k] = temp;
            }
        }

        // For every other row (j),
        // compute the subtractions of the current row (i)
        // necessary to zero out the ith column.
        for (j in 0...n) {
            if (i != j) {
                var p = a[j][i] / a[i][i];

                for (k in 0...n + 1)
                    a[j][k] -= a[i][k] * p;
            }
        }
    }

    return flag;
}

/**
 * Once in row-echelon form
 * @param a
 * @return Bool
 */
function optimize(m:Vector<Vector<Int>>, n:Int):{a:Int, b:Int} {
    // Only one solution
    if (n < 0) {
        return {
            a: Std.int(m[0][2] / m[0][0]),
            b: Std.int(m[1][2] / m[1][1])
        }
    }

    // Many solutions: optimize for b
    var row = m[1 - n];
    var a = row[0];
    var b = row[1];
    var c = row[2];

    var ret = diophantine(a, b, c);
    if (ret == null)
        return {a: 0, b: 0};
    var ac = ret.v.x;
    var bc = ret.v.y;
    var r = ret.r;

    return shiftSearch(ac, bc, Std.int(b / r), Std.int(a / r));
}

/**
 * Getting a and b to positive values, with b minimized.
 */
function shiftSearch(a:Int, b:Int, aShift:Int, bShift:Int):{a:Int, b:Int} {
    while (b < 0) {
        b += bShift;
        a -= aShift;

        return {a: a, b: b};
    }

    while (b - bShift >= 0) {
        b -= bShift;
        a += aShift;
    }

    return {a: a, b: b};
}

/**
 * a must be greater than b
 */
function diophantine(a:Int, b:Int, c:Int) {
    // 258                    1   0
    // 147                    0   1
    // 111 = 258 - 1 * 147    1  -1
    // 36  = 147 - 1 * 111   -1   2
    // 3   = 111 - 3 * 36     4  -7
    // 0   = 36 - 12 * 3

    var swap = a < b;
    if (swap) {
        var t = a;
        a = b;
        b = t;
    }

    // Most recent first
    var history = [new Vec2(0, 1), new Vec2(1, 0)];
    var rem;
    while ((rem = a % b) > 0) {
        var div = Std.int(a / b);
        var next = history[1] - (div * history[0]);
        history[1] = history[0];
        history[0] = next;
        a = b;
        b = rem;
    }
    // b now holds the GCD

    if (c % b != 0)
        return null;

    var v = history[0] * Std.int(c / b);
    if (swap) {
        var t = v.x;
        v.x = v.y;
        v.y = t;
    }

    return {
        v: v,
        r: b
    };
}
