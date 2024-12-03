import haxe.Timer;

typedef TestData = {
    var data:String;
    var expected:Array<Dynamic>;
}

abstract class DayEngine {
    abstract function problem1(data:String):Dynamic;
    abstract function problem2(data:String):Dynamic;

    public function new(data:String, ?tests:Array<TestData>) {
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

                        if (result == test.expected[x]) {
                            Sys.print("✅");
                        } else {
                            Sys.print("❌");
                        }
                    }
                }

                Sys.println("");

                var result = problem(data);

                Sys.println(result == null ? "No result" : result);
            });
        }
    }
}
