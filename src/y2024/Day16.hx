package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;
import util.HashSet;
import util.Heap;
import util.Vec2;

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
var test3 = "
#####
#...E
#.#.#
S...#
#####";

class Day16 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            {data: test1, expected: [7036, 45]},
            {data: test2, expected: [11048, 64]},
            {data: test3, expected: [2006, 10]}
        ];

        new Day16(data, tests, false);
    }

    function problem1(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);

        var nodeMap:Vector<Vector<Vector<Node>>> = new Vector(lines.length);

        var nodeHeap:Heap<Edge> = new Heap((a:Edge, b:Edge) -> {
            var diff = a.d - b.d;
            if (diff == 0)
                return 0;
            if (diff < 0)
                return -1;
            return 1;
        });

        var nodeCount = 0;

        for (i => line in lines) {
            var nodes = new Vector(line.length);

            for (j in 0...line.length) {
                var c = line.charAt(j);
                if (c == '#')
                    continue;

                var quad = createNodeQuad(i, j, c == 'E');
                nodeCount += 4;

                if (i > 0 && nodeMap[i - 1][j] != null) {
                    var northQuad:Quad = nodeMap[i - 1][j];
                    northQuad.south.edges.push({n: quad.south, d: 1, p: null});
                    quad.north.edges.push({n: northQuad.north, d: 1, p: null});
                }
                if (j > 0 && nodes[j - 1] != null) {
                    var westQuad:Quad = nodes[j - 1];
                    westQuad.east.edges.push({n: quad.east, d: 1, p: null});
                    quad.west.edges.push({n: westQuad.west, d: 1, p: null});
                }

                if (c == 'S')
                    nodeHeap.push({n: quad.east, d: 0, p: null});

                nodes[j] = quad;
            }

            nodeMap[i] = nodes;
        }

        var curr:Edge = null;

        do {
            curr = nodeHeap.pop();
            for (e in curr.n.edges)
                if (e.n.visitedAt == 0x7FFFFFFF)
                    nodeHeap.push({n: e.n, d: e.d + curr.d, p: curr});

            curr.n.visitedAt = curr.d;
        } while (!curr.n.terminal);

        return curr.d;
    }

    function problem2(data:String):Any {
        var lines = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);

        var nodeMap:Vector<Vector<Vector<Node>>> = new Vector(lines.length);

        var nodeHeap:Heap<Edge> = new Heap((a:Edge, b:Edge) -> {
            var diff = a.d - b.d;
            if (diff == 0)
                return 0;
            if (diff < 0)
                return -1;
            return 1;
        });

        var nodeCount = 0;

        for (i => line in lines) {
            var nodes = new Vector(line.length);

            for (j in 0...line.length) {
                var c = line.charAt(j);
                if (c == '#')
                    continue;

                var quad = createNodeQuad(i, j, c == 'E');
                nodeCount += 4;

                if (i > 0 && nodeMap[i - 1][j] != null) {
                    var northQuad:Quad = nodeMap[i - 1][j];
                    northQuad.south.edges.push({n: quad.south, d: 1, p: null});
                    quad.north.edges.push({n: northQuad.north, d: 1, p: null});
                }
                if (j > 0 && nodes[j - 1] != null) {
                    var westQuad:Quad = nodes[j - 1];
                    westQuad.east.edges.push({n: quad.east, d: 1, p: null});
                    quad.west.edges.push({n: westQuad.west, d: 1, p: null});
                }

                if (c == 'S')
                    nodeHeap.push({n: quad.east, d: 0, p: null});

                nodes[j] = quad;
            }

            nodeMap[i] = nodes;
        }

        var curr:Edge = null;

        do {
            curr = nodeHeap.pop();
            for (e in curr.n.edges)
                if (e.n.visitedAt >= e.d + curr.d)
                    nodeHeap.push({n: e.n, d: e.d + curr.d, p: curr});

            curr.n.visitedAt = curr.d;
        } while (!curr.n.terminal);

        var pathDistance = curr.d;
        var terminals = [];

        while (curr.d == pathDistance) {
            if (curr.n.terminal)
                terminals.push(curr);

            curr = nodeHeap.pop();
        }

        var visitedNodes = new HashSet<Vec2>();

        for (term in terminals) {
            var at = term;
            while (at != null) {
                visitedNodes.set([at.n.j, at.n.i]);
                at = at.p;
            }
        }

        return visitedNodes.length;
    }
}

typedef Edge = {
    var n:Node;
    var p:Edge;
    var d:Int;
}

class Node {
    public final i:Int;
    public final j:Int;
    public final edges:Array<Edge> = [];
    public final terminal:Bool;
    public var visitedAt = 0x7FFFFFFF;

    public function new(i, j, terminal:Bool = false) {
        this.i = i;
        this.j = j;
        this.terminal = terminal;
    }

    public function toString() {
        return '<$i $j> ($visitedAt)';
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

function createNodeQuad(i, j, terminal:Bool):Quad {
    var north = new Node(i, j, terminal);
    var east = new Node(i, j, terminal);
    var south = new Node(i, j, terminal);
    var west = new Node(i, j, terminal);

    north.edges.push({n: east, d: 1000, p: null});
    north.edges.push({n: west, d: 1000, p: null});

    east.edges.push({n: north, d: 1000, p: null});
    east.edges.push({n: south, d: 1000, p: null});

    south.edges.push({n: east, d: 1000, p: null});
    south.edges.push({n: west, d: 1000, p: null});

    west.edges.push({n: south, d: 1000, p: null});
    west.edges.push({n: north, d: 1000, p: null});

    return Vector.fromArrayCopy([north, east, south, west]);
}
