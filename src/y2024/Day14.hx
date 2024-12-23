package y2024;

import DayEngine.TestData;
import Sure.sure;
import haxe.ds.Vector;
import util.Vec2;

using Lambda;
using StringTools;

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
        var tests:Array<TestData> = [{data: testData, expected: []}];

        var dest = move([2, 4], [2, -3], 5, [11, 7]);
        sure(dest.x == 1);
        sure(dest.y == 3);

        new Day14(data, tests, true);
    }

    function problem1(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);

        var regex = ~/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/;
        var time = 100;
        var size = new Vec2(101, 103);
        var dests = lines.map(str -> {
            regex.match(str);

            var p = new Vec2(Std.parseInt(regex.matched(1)), Std.parseInt(regex.matched(2)));
            var v = new Vec2(Std.parseInt(regex.matched(3)), Std.parseInt(regex.matched(4)));

            return move(p, v, time, size);
        });

        var midX = (size.x - 1) / 2;
        var midY = (size.y - 1) / 2;
        var quadCounts = [0, 0, 0, 0];
        for (d in dests) {
            if (d.x == midX || d.y == midY)
                continue;

            if (d.x < midX)
                if (d.y < midY)
                    quadCounts[0]++;
                else
                    quadCounts[1]++;
            else if (d.y < midY)
                quadCounts[2]++;
            else
                quadCounts[3]++;
        }

        return quadCounts.fold((i, r) -> i * r, 1);
    }

    function problem2(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);

        var regex = ~/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/;
        var ps:Array<Vec2> = [];
        var vs:Array<Vec2> = [];

        for (str in lines) {
            regex.match(str);

            ps.push(new Vec2(Std.parseInt(regex.matched(1)), Std.parseInt(regex.matched(2))));
            vs.push(new Vec2(Std.parseInt(regex.matched(3)), Std.parseInt(regex.matched(4))));
        }

        var size = new Vec2(101, 103);

        var display:Vector<Vector<Int>> = new Vector(size.y);
        for (i in 0...size.y)
            display[i] = new Vector(size.x, 0);

        // 7371 ???
        // Weird pattern every 103 steps, starting at 58 steps
        var step = 103;
        var count = 7371 - step;

        for (i in 0...ps.length) {
            ps[i] = move(ps[i], vs[i], 7371, size);
        }

        while (true) {
            count += step;

            for (i in 0...ps.length) {
                var p = ps[i];
                display[p.y][p.x]++;
                ps[i] = move(p, vs[i], step, size);
            }

            var hasFullRow = false;
            for (row in display) {
                // var fullSoFar = true;
                // for (v in row)
                //     if (v == 0) {
                //         fullSoFar = false;
                //         break;
                //     }

                var sum = 0;
                for (i in row)
                    sum += i;
                var fullSoFar = sum > 31;

                if (fullSoFar) {
                    hasFullRow = true;
                    break;
                }
            }

            for (row in display) {
                for (i in 0...row.length) {
                    var v = row[i];
                    if (hasFullRow)
                        Sys.print(v > 0 ? v : ' ');
                    row[i] = 0;
                }
                if (hasFullRow)
                    Sys.println('');
            }

            // Sys.print('$count ');

            if (hasFullRow && Sys.stdin().readLine().length > 0)
                break;
        }

        return count;
    }
}

function move(p:Vec2, v:Vec2, t:Int, s:Vec2):Vec2 {
    return ((p + v * t) % s + s) % s;
}
