package y2024;

import DayEngine.TestData;
import util.HashSet;
import util.Vec2;

using StringTools;

var testData = "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE";

class Day12 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: [1930]}];

        new Day12(data, tests, true);
    }

    function problem1(data:String):Dynamic {
        var map:Array<Array<Int>> = data.split('\n').map(s -> s.trim()).filter(s -> s.length > 0).map(s -> {
            var arr = [];
            for (i in 0...s.length)
                arr.push(s.charCodeAt(i));

            return arr;
        });

        var coords = new HashSet<Vec2>(map.length * map[0].length);
        for (i in 0...map.length)
            for (j in 0...map[0].length)
                coords.set(new Vec2(j, i));

        var sum = 0;

        while (coords.length > 0) {
            var start = coords.values()[0];
            // Sys.println('Region: ${String.fromCharCode(map[start.y][start.x])} ${start.toString()}');
            var price = getRegionPrice(map, coords, start);
            // Sys.println('Price: $price');
            sum += price;
        }

        return sum;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

function getRegionPrice(map:Array<Array<Int>>, coords:HashSet<Vec2>, start:Vec2):Int {
    var n = map[start.y][start.x];
    var area:Int = 0;
    var perimeter:Int = 0;

    coords.remove(start);
    var queue:Array<Vec2> = [start];

    var coord;
    while ((coord = queue.pop()) != null) {
        ++area;
        var x = coord.x;
        var y = coord.y;

        var vecs:Array<Vec2> = [];

        if (x - 1 >= 0 && map[y][x - 1] == n)
            vecs.push(new Vec2(x - 1, y));
        if (y - 1 >= 0 && map[y - 1][x] == n)
            vecs.push(new Vec2(x, y - 1));
        if (x + 1 < map[0].length && map[y][x + 1] == n)
            vecs.push(new Vec2(x + 1, y));
        if (y + 1 < map.length && map[y + 1][x] == n)
            vecs.push(new Vec2(x, y + 1));

        perimeter += 4 - vecs.length;

        for (vec in vecs) {
            if (coords.remove(vec)) {
                queue.unshift(vec);
            }
        }
    }

    // Sys.println('$area $perimeter');

    return area * perimeter;
}
