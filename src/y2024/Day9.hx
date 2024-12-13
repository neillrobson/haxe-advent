package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;

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
**/
class Day9 extends DayEngine {
	public static function make(data:String) {
		var tests:Array<TestData> = [{data: testData, expected: ["1928"]},];

		new Day9(data, tests, true);
	}

	function problem1(data:String):Dynamic {
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

	function problem2(data:String):Dynamic {
		return null;
	}
}

inline function tri(n:Int) {
	return (n * (n - 1)) >> 1;
}
