package y2024;

import DayEngine.TestData;
import haxe.ds.HashMap;
import util.Vec2;

using StringTools;

var testData = "
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
";

class Day8 extends DayEngine {
	public static function make(data:String) {
		var tests:Array<TestData> = [{data: testData, expected: [14]}];

		new Day8(data, tests, true);
	}

	function problem1(data:String):Dynamic {
		var parsed:Array<String> = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0);
		var length = parsed.length;
		var width = parsed[0].length;

		var antinodeCount = 0;
		var antinodes:HashMap<Vec2Data, Bool> = new HashMap();
		var nodes:Map<String, Array<Vec2>> = [];

		for (i => row in parsed) {
			for (j in 0...width) {
				var c = row.charAt(j);

				if (c == '.')
					continue;

				var v = new Vec2(j, i);

				if (!nodes.exists(c)) {
					nodes[c] = [v];
					continue;
				}

				for (node in nodes[c]) {
					var a = 2 * v - node;
					if (check(a, length, width) && !antinodes.exists(a)) {
						antinodes.set(a, true);
						++antinodeCount;
					}

					a = 2 * node - v;
					if (check(a, length, width) && !antinodes.exists(a)) {
						antinodes.set(a, true);
						++antinodeCount;
					}
				}

				nodes[c].push(v);
			}
		}

		return antinodeCount;
	}

	function problem2(data:String):Dynamic {
		return null;
	}
}

inline function check(v:Vec2, length:Int, width:Int) {
	return v.x >= 0 && v.x < width && v.y >= 0 && v.y < length;
}
