import DayEngine.TestData;

var testData = "";

class DayX extends DayEngine {
    public static function make(data:String) {
        var tests:Array<TestData> = [{data: testData, expected: []}];

        new DayX(data, tests, false);
    }

    function problem1(data:String):Any {
        return null;
    }

    function problem2(data:String):Any {
        return null;
    }
}
