package y2024;

import DayEngine.TestData;

using Lambda;

var testData = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))';

class Day3 extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [
            { data: testData, expected: [161, null] },
            { data: "mul(2,4),mul(5,5),mul(11,8),mul(8,5)", expected: [161, null] }
        ];

        new Day3(data, tests);
    }

    function problem1(data:String):Dynamic {
        var charArr = ['', 'm', 'u', 'l', '(', '0123456789', ',', ')'];

        var states:Array<Array<Array<Int>>> = [];

        // waiting for m u l ( 0-9+ , 0-9+ ) [end]
        for (i in 0...9) {
            var row = [];
            for (_ in 0...charArr.length) row.push(i == 8 ? [0, 3] : [0, 0]);
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

        var mulRegex = ~/mul\((\d+),(\d+)\)/;

        return res.fold((item, result) -> {
            if (!mulRegex.match(item)) return result;

            var a = Std.parseInt(mulRegex.matched(1));
            var b = Std.parseInt(mulRegex.matched(2));

            return result + a * b;
        }, 0);
    }

    function problem2(data:String):Dynamic {
        return null;
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
            for (ci in 0...v.length) charMap[v.charAt(ci)] = i;
        };

        this.charMap = charMap;
    }

    public function run(data:String):Array<String> {
        // Word pointer
        var j = -1;
        // Row pointer
        var r = 0;

        var out = [];

        for (i in 0...data.length) {
            var c = charMap[data.charAt(i)];
            if (c == null) c = 0;

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

        if (j >= 0) {
            out.push(data.substring(j));
        }

        return out;
    }
}
