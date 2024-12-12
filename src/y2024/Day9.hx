package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;

using StringTools;
using haxe.Int64;

var testData = "2333133121414131402";

// 6085166247730 is too low

class Day9 extends DayEngine {
	public static function make(data:String) {
		var tests:Array<TestData> = [{data: testData, expected: ["1928"]}, {data: "12345", expected: ["60"]},];

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

				var fileID = forwardIndex >> 1;
				sum += (spaceToFill * blockPosition + tri(spaceToFill)) * fileID;
				blockPosition += spaceToFill;

				++forwardIndex;
			} else {
				var fRemaining = fEntry - forwardUsed;
				var bRemaining = bEntry - backwardUsed;
				var spaceToFill = Std.int(Math.min(fRemaining, bRemaining));

				var fileID = backwardIndex >> 1;
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
