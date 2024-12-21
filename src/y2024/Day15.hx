package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;
import util.HashSet;
import util.Vec2;

using StringTools;

var testSmall = "########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<";
var testMedium = "##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^";

// enum Dir {
//     Up;
//     Right;
//     Down;
//     Left;
// }
// final DIR_VECS:Map<Dir, Vec2> = [Up => [0, -1], Right => [1, 0], Down => [0, 1], Left => [-1, 0]];

final CHAR_VECS:Map<String, Vec2> = ['^' => [0, -1], '>' => [1, 0], 'v' => [0, 1], '<' => [-1, 0]];

@:forward
abstract Addressable<T>(Vector<Vector<T>>) from Vector<Vector<T>> to Vector<Vector<T>> {
    public function new(v:Vector<Vector<T>>) {
        this = v;
    }

    @:op([])
    public function arrayRead(v:Vec2)
        return this[v.y][v.x];

    @:op([])
    public function arrayWrite(v:Vec2, t:T)
        return this[v.y][v.x] = t;
}

class Day15 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testSmall, expected: [2028]}, {data: testMedium, expected: [10092, 9021]}];

        new Day15(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        var lines = data.split('\n').map(s -> s.trim());

        var mapData:Array<Vector<Int>> = [];

        var pos:Vec2 = null;

        var i = 0;
        var line;
        while ((line = lines[i++]).length > 0) {
            var lineData = [];
            for (j in 0...line.length) {
                var v = 0;
                if (line.charAt(j) == 'O')
                    v = 1;
                if (line.charAt(j) == '#')
                    v = 2;
                if (line.charAt(j) == '@')
                    pos = [j, i - 1];
                lineData.push(v);
            }
            mapData.push(Vector.fromArrayCopy(lineData));
        }

        var map:Vector<Vector<Int>> = Vector.fromArrayCopy(mapData);

        for (k in i...lines.length) {
            line = lines[k];
            for (j in 0...line.length) {
                var dir = CHAR_VECS[line.charAt(j)];
                pos = move(map, pos, dir);
            }
        }

        var sum = 0;
        for (y in 0...map.length) {
            var l = map[y];
            for (x in 0...l.length) {
                var c = l[x];
                if (c == 0)
                    Sys.print('.');
                if (c == 1) {
                    Sys.print('O');
                    sum += 100 * y + x;
                }
                if (c == 2)
                    Sys.print('#');
            }
            Sys.println('');
        }

        return sum;
    }

    function problem2(data:String):Dynamic {
        var lines = data.split('\n').map(s -> s.trim());

        var mapData:Array<Vector<Int>> = [];

        var pos:Vec2 = null;

        var i = 0;
        var line;
        while ((line = lines[i++]).length > 0) {
            var lineData = [];
            for (j in 0...line.length) {
                switch (line.charAt(j)) {
                    case 'O':
                        lineData.push(1);
                        lineData.push(3);
                    case '#':
                        lineData.push(2);
                        lineData.push(2);
                    case '@':
                        lineData.push(0);
                        lineData.push(0);
                        pos = [j, i - 1];
                    default:
                        lineData.push(0);
                        lineData.push(0);
                }
            }
            mapData.push(Vector.fromArrayCopy(lineData));
        }

        var map:Vector<Vector<Int>> = Vector.fromArrayCopy(mapData);

        Sys.println('');
        for (y in 0...map.length) {
            var l = map[y];
            for (x in 0...l.length) {
                var c = l[x];
                if (c == 0)
                    Sys.print('.');
                if (c == 1) {
                    Sys.print('[');
                    // sum += 100 * y + x;
                }
                if (c == 2)
                    Sys.print('#');
                if (c == 3)
                    Sys.print(']');
            }
            Sys.println('');
        }

        for (k in i...lines.length) {
            line = lines[k];
            for (j in 0...line.length) {
                var dir = CHAR_VECS[line.charAt(j)];
                pos = move(map, pos, dir);
            }
        }

        var sum = 0;
        Sys.println('');
        for (y in 0...map.length) {
            var l = map[y];
            for (x in 0...l.length) {
                var c = l[x];
                if (c == 0)
                    Sys.print('.');
                if (c == 1) {
                    Sys.print('[');
                    sum += 100 * y + x;
                }
                if (c == 2)
                    Sys.print('#');
                if (c == 3)
                    Sys.print(']');
            }
            Sys.println('');
        }

        return sum;
    }
}

function move(map:Addressable<Int>, pos:Vec2, dir:Vec2):Vec2 {
    var hope = pos + dir;

    var push = hope;
    while (map[push] == 1) {
        push += dir;
    }

    // Can't move due to wall
    if (map[push] == 2)
        return pos;

    // Move some boxes
    if (push != hope) {
        map[hope] = 0;
        map[push] = 1;
    }

    return hope;
}

function moveWide(map:Addressable<Int>, pos:Vec2, dir:Vec2):Vec2 {
    var hope = pos + dir;

    var vecsToPush:Array<Vec2> = [];

    var sets = [new HashSet<Vec2>(), new HashSet<Vec2>()];
    var nextSetIdx = 0;
    var activeSet = sets[nextSetIdx];
    activeSet.set(hope);

    while (activeSet.length > 0) {
        nextSetIdx = 1 - nextSetIdx;
        var nextSet = sets[nextSetIdx];

        for (v in activeSet.values()) {
            // Can't push due to a wall
            if (map[v] == 2)
                return pos;

            // No action needed
            if (map[v] == 0) {
                continue;
            }

            vecsToPush.unshift(v);
            nextSet.set(v + dir);

            // Moving vertically
            if (dir.y != 0) {
                var buddy = v + [map[v] == 1 ? 1 : -1, 0];
                if (nextSet.set(buddy + dir)) {
                    vecsToPush.unshift(buddy);
                }
            }
        }

        activeSet.clear();
        activeSet = nextSet;
    }

    for (v in vecsToPush) {
        map[v + dir] = map[v];
    }

    return hope;
}
