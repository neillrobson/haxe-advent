package y2024;

import DayEngine.TestData;

using Lambda;
using StringTools;

var testData = 'MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
';

class Day4 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [18, null] }
        ];

        new Day4(data, tests, false);
    }

    function problem1(data:String):Dynamic {
        var matrix = new StringMatrix(data);

        var count = 0;
        count += matrix.checkHorizontal('XMAS');
        count += matrix.checkVertical('XMAS');
        count += matrix.checkLeadingDiagonal('XMAS');
        count += matrix.checkCounterDiagonal('XMAS');

        Sys.println(count);

        return count;
    }

    function problem2(data:String):Dynamic {
        return null;
    }
}

class StringMatrix {
    final data:Array<String>;

    public function new(data:String) {
        this.data = data.split('\n').filter((line) -> line.length > 0);
    }

    public function checkHorizontal(search:String) {
        return findMatches(search, data);
    }

    public function checkVertical(search:String) {
        var transpose:Array<String> = [];

        for (i in 0...data[0].length) {
            var line = new StringBuf();

            for (j in 0...data.length)
                line.addChar(data[j].fastCodeAt(i));

            transpose.push(line.toString());
        }

        return findMatches(search, transpose);
    }

    public function checkLeadingDiagonal(search:String) {
        var diags:Array<String> = [];
        var diagCount = data.length + data[0].length;

        for (i in 0...diagCount) {
            var line = new StringBuf();

            var startRow = Std.int(Math.max(0, i - data[0].length));
            var endRow = Std.int(Math.min(i + 1, data.length));

            var offset = Std.int(Math.max(data[0].length - i - 1, 0));
            var rows = [for (j in startRow...endRow) data[j]];

            for (idx => row in rows)
                line.addChar(row.fastCodeAt(offset + idx));

            diags.push(line.toString());
        }

        return findMatches(search, diags);
    }

    public function checkCounterDiagonal(search:String) {
        return 0;
    }
}

/** Will not find overlapping matches in the same direction (e.g. if prefix and suffix are identical). **/
function findMatches(search:String, data:Array<String>) {
    final reg = new EReg(search, '');

    return data.fold((line, count) -> {
        var processing = line;

        while (reg.match(processing)) {
            count++;
            processing = reg.matchedRight();
        }

        processing = reverse(line);

        while (reg.match(processing)) {
            count++;
            processing = reg.matchedRight();
        }

        return count;
    }, 0);
}

function reverse(s:String):String {
    var ret = new StringBuf();

    for (i in -s.length+1...1)
        ret.addChar(s.fastCodeAt(-i));

    return ret.toString();
}
