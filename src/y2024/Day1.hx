package y2024;

class Day1 extends DayEngine {
    public static function make(data:String) {
        new Day1(data);
    }

    function problem1(data:String):Dynamic {
        return data.split("\n")[0];
    }

    function problem2(data:String):Dynamic {
        return data.split("\n").length;
    }
}
