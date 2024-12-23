package y2024;

import DayEngine.TestData;

using Lambda;

var testData = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))';

function postProcess(data:Array<String>):Int {
    var mulRegex = ~/mul\((\d+),(\d+)\)/;

    return data.fold((item, result) -> {
        if (!mulRegex.match(item))
            return result;

        var a = Std.parseInt(mulRegex.matched(1));
        var b = Std.parseInt(mulRegex.matched(2));

        return result + a * b;
    }, 0);
}

class Day3 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            {data: testData, expected: [161, 161]},
            {data: "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))", expected: [161, 48]},
            {data: "mul(2,4),mul(5,5),mul(11,8),mul(8,5)", expected: [161, 161]},
            {data: "mumul(2,4),mul(5,5),mul(11,8),mul(8,5)", expected: [161, 161]},
            {data: "mudon't()l(8,5)", expected: [0, 0]},
            {data: "mudo()l(8,5)", expected: [0, 0]},
            {data: "mul(8,5)don't()do()mul(8,5)", expected: [80, 80]},
            {data: "mul(8,5)don't()do(')mul(8,5)", expected: [80, 40]},
        ];

        new Day3(data, tests);
    }

    function problem1(data:String):Any {
        var charArr = ['', 'm', 'u', 'l', '(', '0123456789', ',', ')'];

        var states:Array<Array<Array<Int>>> = [];

        // waiting for m u l ( 0-9+ , 0-9+ ) [end]
        for (i in 0...9) {
            var row = [];
            for (j in 0...charArr.length) {
                if (j == 1)
                    row.push([1, 1]);
                else if (i == 8)
                    row.push([0, 3]);
                else
                    row.push([0, 0]);
            }
            states.push(row);
        }

        states[0][1] = [1, 1]; // m
        states[1][2] = [2, 0]; // u
        states[2][3] = [3, 0]; // l
        states[3][4] = [4, 0]; // (
        states[4][5] = [5, 0]; // 0-9
        states[5][5] = [5, 0]; // 0-9+
        states[5][6] = [6, 0]; // ,
        states[6][5] = [7, 0]; // 0-9
        states[7][5] = [7, 0]; // 0-9+
        states[7][7] = [8, 0]; // )
        states[8][1] = [1, 2]; // received another "m"

        var fsm = new FSM(states, charArr);
        var res = fsm.run(data);

        return postProcess(res);
    }

    function problem2(data:String):Any {
        var charArr = ['', 'm', 'u', 'l', '(', '0123456789', ',', ')', 'd', 'o', 'n', "'", 't'];

        var states:Array<Array<Array<Int>>> = [];

        for (i in 0...19) {
            var row = [];
            for (j in 0...charArr.length) {
                if (i < 15) {
                    // Allow for "mul" and "don't"
                    if (j == 1)
                        row.push([1, 1]);
                    else if (j == 8)
                        row.push([9, 0]);
                    else if (i == 8)
                        row.push([0, 3]);
                    else
                        row.push([0, 0]);
                } else {
                    // Allow for "do"
                    if (j == 8)
                        row.push([16, 0]);
                    else
                        row.push([15, 0]);
                }
            }
            states.push(row);
        }

        states[0][1] = [1, 1]; // m
        states[1][2] = [2, 0]; // u
        states[2][3] = [3, 0]; // l
        states[3][4] = [4, 0]; // (
        states[4][5] = [5, 0]; // 0-9
        states[5][5] = [5, 0]; // 0-9+
        states[5][6] = [6, 0]; // ,
        states[6][5] = [7, 0]; // 0-9
        states[7][5] = [7, 0]; // 0-9+
        states[7][7] = [8, 0]; // )

        states[8][1] = [1, 2]; // received another "m"
        states[8][8] = [9, 3]; // d

        states[0][8] = [9, 0]; //    d
        states[9][9] = [10, 0]; //  o
        states[10][10] = [11, 0]; // n
        states[11][11] = [12, 0]; // '
        states[12][12] = [13, 0]; // t
        states[13][4] = [14, 0]; // (
        states[14][7] = [15, 0]; // )

        states[15][8] = [16, 0]; //  d
        states[16][9] = [17, 0]; //  o
        states[17][4] = [18, 0]; // (
        states[18][7] = [0, 0]; //  )

        var fsm = new FSM(states, charArr);
        var res = fsm.run(data);

        return postProcess(res);
    }
}

class FSM {
    /**
        Row pointer -> Input index -> [New row, Action]

        Actions:
        0: Do nothing
        1: Start new word
        2: Add word, start new word
        3: Add word, reset word pointer
        6: Stop
    **/
    final states:Array<Array<Array<Int>>>;

    final charMap:Map<String, Int>;

    public function new(states:Array<Array<Array<Int>>>, charArr:Array<String>) {
        this.states = states;

        var charMap:Map<String, Int> = [];
        for (i => v in charArr) {
            for (ci in 0...v.length)
                charMap[v.charAt(ci)] = i;
        };

        this.charMap = charMap;
    }

    public function run(data:String):Array<String> {
        // Word pointer
        var j = -1;
        // Row pointer
        var r = 0;

        var out = [];

        for (i in 0...data.length + 1) {
            var c = i == data.length ? 0 : charMap[data.charAt(i)];
            if (c == null)
                c = 0;

            var state = states[r][c];
            r = state[0];
            var action = state[1];

            switch (action) {
                case 1:
                    j = i;
                case 2:
                    out.push(data.substring(j, i));
                    j = i;
                case 3:
                    out.push(data.substring(j, i));
                    j = -1;
                case 6:
                    return out;
            }
        }

        return out;
    }
}
