import haxe.Timer;

abstract class DayEngine {
    abstract function problem1(data:String):Dynamic;
    abstract function problem2(data:String):Dynamic;

    public function new(data:String) {
        for (problem in [problem1, problem2]) {
            Timer.measure(() -> {
                var result = problem(data);

                Sys.println(result == null ? "No result" : result);
            });
        }
    }
}
