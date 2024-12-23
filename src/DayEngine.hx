import haxe.Timer;

using haxe.Int64;

typedef TestData = {
    var data:String;
    var expected:Array<Any>;
}

abstract class DayEngine {
    abstract function problem1(data:String):Any;

    abstract function problem2(data:String):Any;

    public function new(data:String, ?tests:Array<TestData>, run = true) {
        for (x => problem in [problem1, problem2]) {
            Timer.measure(() -> {
                Sys.print('Problem ${x + 1}: ');

                if (tests != null) {
                    for (test in tests) {
                        if (test.expected.length <= x || test.expected[x] == null) {
                            Sys.print("❓");
                            continue;
                        }

                        var result = problem(test.data);
                        var expected = test.expected[x];

                        if (result.isInt64() && expected.isInt64() && (result : Int64) == (expected : Int64)) {
                            Sys.print("✅");
                        } else if (result == expected) {
                            Sys.print("✅");
                        } else {
                            Sys.print("❌");
                        }
                    }
                }

                Sys.println("");

                if (run) {
                    var result = problem(data);
                    Sys.println(result == null ? "No result" : result);
                }
            });
        }
    }
}
