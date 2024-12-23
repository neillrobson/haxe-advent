package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;
import util.Heap;

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

        var nodeHeap:Heap<Edge> = new Heap((a:Edge, b:Edge) -> a.d - b.d);

        for (i => line in lines) {
            var nodes = new Vector(line.length);

            for (j in 0...line.length) {
                var c = line.charAt(j);
                if (c == '#')
                    continue;

                var quad = createNodeQuad(c == 'E');

                if (i > 0 && nodeMap[i - 1][j] != null) {
                    var northQuad:Quad = nodeMap[i - 1][j];
                    northQuad.south.edges.push({n: quad.south, d: 1});
                    quad.north.edges.push({n: northQuad.north, d: 1});
                }
                if (j > 0 && nodes[j - 1] != null) {
                    var westQuad:Quad = nodes[j - 1];
                    westQuad.east.edges.push({n: quad.east, d: 1});
                    quad.west.edges.push({n: westQuad.west, d: 1});
                }

                if (c == 'S')
                    nodeHeap.push({n: quad.east, d: 0});

                nodes[j] = quad;
            }

            nodeMap[i] = nodes;
        }

        return null;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

typedef Edge = {
    var n:Node;
    var d:Int;
}

class Node {
    public final edges:Array<Edge> = [];
    public final terminal:Bool;

    public function new(terminal:Bool = false) {
        this.terminal = terminal;
    }
}

abstract Quad(Vector<Node>) from Vector<Node> to Vector<Node> {
    public inline function new(v:Vector<Node>) {
        this = v;
    }

    @:op(a.b)
    public inline function fieldRead(name:String) {
        switch (name) {
            case "north":
                return this[0];
            case "east":
                return this[1];
            case "south":
                return this[2];
            case "west":
                return this[3];
            default:
                return null;
        }
    }

    @:op(a.b)
    public inline function fieldWrite(name:String, value:Node) {
        switch (name) {
            case "north":
                return this[0] = value;
            case "east":
                return this[1] = value;
            case "south":
                return this[2] = value;
            case "west":
                return this[3] = value;
            default:
                return value;
        }
    }
}

function createNodeQuad(terminal:Bool):Quad {
    var north = new Node(terminal);
    var east = new Node(terminal);
    var south = new Node(terminal);
    var west = new Node(terminal);

    north.edges.push({n: east, d: 1000});
    north.edges.push({n: south, d: 1000});
    north.edges.push({n: west, d: 1000});

    east.edges.push({n: north, d: 1000});
    east.edges.push({n: south, d: 1000});
    east.edges.push({n: west, d: 1000});

    south.edges.push({n: east, d: 1000});
    south.edges.push({n: north, d: 1000});
    south.edges.push({n: west, d: 1000});

    west.edges.push({n: east, d: 1000});
    west.edges.push({n: south, d: 1000});
    west.edges.push({n: north, d: 1000});

    return Vector.fromArrayCopy([north, east, south, west]);
}
