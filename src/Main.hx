/**
    Documentation.
**/

class Main {
    static public function main():Void {
        var strings:Array<String> = [];

        strings.push("World");
        strings.insert(0, "Hello");

        trace(strings.join(" "));
    }
}
