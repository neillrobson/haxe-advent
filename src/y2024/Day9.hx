package y2024;

import DayEngine.TestData;
import haxe.ds.Vector;

using StringTools;
using haxe.Int64;

var testData = "2333133121414131402";

class Day9 extends DayEngine {
	public static function make(data:String) {
		var tests:Array<TestData> = [{data: testData, expected: [1928]}, {data: "12345", expected: ["132"]},];

		new Day9(data, tests, false);
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
				var fileID = forwardIndex >> 1;
				sum += (fEntry * blockPosition + tri(fEntry)) * fileID;
				blockPosition += fEntry;
				++forwardIndex;
			} else {
				if (fEntry - forwardUsed == bEntry - backwardUsed) {
					// TODO for each situation <, >, ==
				}
				blockPosition += fEntry;
				++forwardIndex;
			}
		}

		Sys.println(sum.toStr());
		return sum.toStr();
	}

	function problem2(data:String):Dynamic {
		return null;
	}
}

inline function tri(n:Int) {
	return (n * (n - 1)) >> 1;
}
