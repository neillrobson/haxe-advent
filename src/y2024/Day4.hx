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
            { data: testData, expected: [18, 9] }
        ];

        new Day4(data, tests);
    }

    function problem1(data:String):Dynamic {
        var matrix = new StringMatrix(data);

        var count = 0;
        count += matrix.checkHorizontal('XMAS');
        count += matrix.checkVertical('XMAS');
        count += matrix.checkLeadingDiagonal('XMAS');
        count += matrix.checkCounterDiagonal('XMAS');

        return count;
    }

    function problem2(data:String):Dynamic {
        var matrix = data.split('\n').filter((line) -> line.length > 0);
        var count = 0;

        for (y in 1...matrix.length - 1) {
            for (x in 1...matrix[0].length - 1) {
                if (
                    checkXMAS(
                        matrix[y].charAt(x),
                        matrix[y-1].charAt(x-1),
                        matrix[y-1].charAt(x+1),
                        matrix[y+1].charAt(x-1),
                        matrix[y+1].charAt(x+1)
                    )
                ) count++;
            }
        }

        return count;
    }
}

function checkXMAS(c:String, tl:String, tr:String, bl:String, br:String) {
    if (c != "A") return false;

    if (!"MS".contains(tl)) return false;
    if (!"MS".contains(tr)) return false;
    if (!"MS".contains(bl)) return false;
    if (!"MS".contains(br)) return false;

    if (tl != tr && tl != bl) return false;
    if (br != tr && br != bl) return false;

    if (tl == br) return false;

    return true;
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
        var diagCount = data.length + data[0].length - 1;

        for (i in 0...diagCount) {
            var line = new StringBuf();

            var startRow = Std.int(Math.max(0, i - data[0].length + 1));
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
        var diags:Array<String> = [];
        var diagCount = data.length + data[0].length - 1;

        for (i in 0...diagCount) {
            var line = new StringBuf();

            // Going in a negative order
            var startRow = Std.int(Math.min(i, data.length - 1));
            var endRow = Std.int(Math.max(-1, i - data[0].length));

            /**
                dl - (diagCount - i)
                dl - (dl + d0l - i)
                dl - dl - d0l + i
                -d0l + i
                i - d0l
            **/

            var offset = Std.int(Math.max(i - data.length + 1, 0));
            var rows = [for (j in -startRow...-endRow) data[-j]];

            for (idx => row in rows)
                line.addChar(row.fastCodeAt(offset + idx));

            diags.push(line.toString());
        }

        return findMatches(search, diags);
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
