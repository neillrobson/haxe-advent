package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;

using StringTools;

var test1 = "
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############";
var test2 = "
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################";

class Day16 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: test1, expected: [7036]}, {data: test2, expected: [11048]}];

        new Day16(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);

        var nodeMap:Vector<Vector<Vector<Node>>> = new Vector(lines.length);

        for (i => line in lines) {
            var nodes = new Vector(line.length);

            for (j in 0...line.length) {
                var c = line.charAt(j);
                if (c == '#')
                    continue;
            }

            nodeMap[i] = nodes;
        }

        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

class Node {
    public final edges:Array<{n:Node, d:Int}> = [];
    public final terminal:Bool;

    public function new(terminal:Bool = false) {
        this.terminal = terminal;
    }
}
