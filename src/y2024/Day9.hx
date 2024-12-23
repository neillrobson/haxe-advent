package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;
import util.Heap;
import util.LinkedList;

using StringTools;
using haxe.Int64;

var testData = "2333133121414131402";

/**
    0          4       8       12       16

    00...111...2...333.44.5555.6666.777.888899
    009..111...2...333.44.5555.6666.777.88889.
    0099.111...2...333.44.5555.6666.777.8888..
    00998111...2...333.44.5555.6666.777.888...
    009981118..2...333.44.5555.6666.777.88....
    0099811188.2...333.44.5555.6666.777.8.....
    009981118882...333.44.5555.6666.777.......
    0099811188827..333.44.5555.6666.77........
    00998111888277.333.44.5555.6666.7.........
    009981118882777333.44.5555.6666...........
    009981118882777333644.5555.666............
    00998111888277733364465555.66.............
    0099811188827773336446555566..............

    0          4       8       12       16

    00...111...2...333.44.5555.6666.777.888899
    0099.111...2...333.44.5555.6666.777.8888..
    0099.1117772...333.44.5555.6666.....8888..
    0099.111777244.333....5555.6666.....8888..
    00992111777.44.333....5555.6666.....8888..

    11329068336370 too high
    10965474020085 too high
    11220449192742 ugh
**/
class Day9 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            {data: testData, expected: ["1928", "2858"]},
            {data: "12345", expected: ["60", "132"]},
            {data: "54321", expected: ["31", "31"]},
            {data: "222", expected: ["5", "5"]},
        ];

        new Day9(data, tests, true);
    }

    function problem1(data:String):Any {
        var d = data.trim();
        var disk:Vector<Int> = new Vector(d.length);
        for (i in 0...disk.length)
            disk[i] = d.unsafeCodeAt(i) - 48;

        var sum:Int64 = 0;

        var forwardIndex = 0;
        var forwardUsed = 0;
        var backwardIndex = d.length - (d.length % 2 == 0 ? 2 : 1);
        var backwardUsed = 0;
        var blockPosition = 0;

        while (forwardIndex <= backwardIndex) {
            var fEntry = disk[forwardIndex];
            var bEntry = disk[backwardIndex];

            if (forwardIndex % 2 == 0) {
                var spaceToFill = forwardIndex == backwardIndex ? fEntry - backwardUsed : fEntry;

                var fileID:Int64 = forwardIndex >> 1;
                sum += (spaceToFill * blockPosition + tri(spaceToFill)) * fileID;
                blockPosition += spaceToFill;

                ++forwardIndex;
            } else {
                var fRemaining = fEntry - forwardUsed;
                var bRemaining = bEntry - backwardUsed;
                var spaceToFill = fRemaining < bRemaining ? fRemaining : bRemaining;

                var fileID:Int64 = backwardIndex >> 1;
                sum += (spaceToFill * blockPosition + tri(spaceToFill)) * fileID;
                blockPosition += spaceToFill;

                if (fRemaining == bRemaining) {
                    ++forwardIndex;
                    forwardUsed = 0;
                    backwardIndex -= 2;
                    backwardUsed = 0;
                } else if (fRemaining < bRemaining) {
                    ++forwardIndex;
                    forwardUsed = 0;
                    backwardUsed += spaceToFill;
                } else {
                    forwardUsed += spaceToFill;
                    backwardIndex -= 2;
                    backwardUsed = 0;
                }
            }
        }

        return sum.toStr();
    }

    function problem2(data:String):Any {
        // Linked list of pairs: [index, width]
        // Empty spaces are always *odd* indexes
        // Heaps of empty spaces per width
        // Traverse right to left, moving file entries backward
        // compute the checksum at the very end

        var d = data.trim();

        var disk = new LinkedList<Pair>();
        // Index into array with [width - 1]
        var leftmostSpaces:Array<Heap<Node<Pair>>> = [for (i in 0...9) new Heap<Node<Pair>>((a, b) -> a.item[0] - b.item[0])];
        var leftmostSpaceIndex = -1;

        for (i in 0...d.length) {
            var width = d.unsafeCodeAt(i) - 48;
            disk.add(pair(i, width));
            if (i % 2 != 0 && width > 0) {
                leftmostSpaces[width - 1].push(disk.lastNode());
                if (leftmostSpaceIndex == -1)
                    leftmostSpaceIndex = i;
            }
        }

        var current = disk.lastNode();
        if (current.item[0] % 2 != 0)
            current = current.prev;

        while (current.item[0] > leftmostSpaceIndex) {
            // Find the previous consecutive file ID (before we re-arrange)
            var prev = current;
            var prevId = current.item[0] - 2;
            while (prev.item[0] != prevId)
                prev = prev.prev;

            var width = current.item[1];

            var leftmostIdx:Int = -1;
            var leftmostHeap:Heap<Node<Pair>> = null;
            for (w in width...10) {
                var heap = leftmostSpaces[w - 1];
                if (heap.length > 0) {
                    var node = heap.peek();
                    if (node.item[0] > current.item[0])
                        continue;
                    if (leftmostIdx == -1 || leftmostIdx > node.item[0]) {
                        leftmostIdx = node.item[0];
                        leftmostHeap = heap;
                    }
                }
            }

            if (leftmostHeap != null) {
                var space = leftmostHeap.pop();

                // Splice in `current`
                var newSpace = new Node(pair(-1, width), null, null);
                disk.splice(newSpace, current);
                disk.remove(current);
                disk.splice(current, space);

                // Reduce size of space
                space.item[1] -= width;
                var rem = space.item[1];

                // Re-insert in correct heap
                if (rem == 0) {
                    if (space.item[0] == leftmostSpaceIndex) {
                        var n = space.next;
                        while (n.item[0] % 2 == 0)
                            n = n.next;
                        leftmostSpaceIndex = n.item[0];
                    }
                    disk.remove(space);
                    if (leftmostSpaceIndex == -1)
                        break;
                } else {
                    leftmostSpaces[rem - 1].push(space);
                }
            }

            current = prev;
        }

        // Calculate checksum
        var sum:Int64 = 0;
        var blockPosition = 0;

        var d = disk.firstNode();
        while (d.item != null) {
            var index = d.item[0];
            var spaceToFill = d.item[1];

            if (index % 2 == 0) {
                var fileID:Int64 = index >> 1;
                sum += (spaceToFill * blockPosition + tri(spaceToFill)) * fileID;
            }

            blockPosition += spaceToFill;
            d = d.next;
        }

        return sum.toStr();
    }
}

inline function tri(n:Int) {
    return (n * (n - 1)) >> 1;
}

typedef Pair = Vector<Int>;

inline function pair(x:Int, y:Int):Pair {
    return Vector.fromArrayCopy([x, y]);
}
