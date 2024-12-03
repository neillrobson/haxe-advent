import sys.FileSystem;
import sys.io.File;

typedef AdventMakeFunc = String -> Void;

class Main {
    var year = 2024;
    var day:Int;

    static function main() {
        new Main(1);
    }

    public function new(?day:Int) {
        var today = Date.now();
        this.day = day == null ? today.getDate() : day;

        var funcMap:Array<AdventMakeFunc> = [
            y2024.Day1.make
        ];

        funcMap[this.day - 1](getInput());
    }

    function getInput():String {
        if (!FileSystem.exists("./cache")) {
            FileSystem.createDirectory("./cache");
        }

        var cachePath = './cache/$year';
        if (!FileSystem.exists(cachePath)) {
            FileSystem.createDirectory(cachePath);
        }

        var cacheFile = '$cachePath/$day.txt';
        if (FileSystem.exists(cacheFile)) {
            return File.getContent(cacheFile);
        }

        return "";
    }
}
