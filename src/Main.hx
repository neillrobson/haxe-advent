import haxe.io.Path;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

typedef AdventMakeFunc = String -> Void;

class Main {
    var year = 2024;
    var day:Int;

    static function main() {
        var args = Sys.args();
        if (args.length > 0) {
            new Main(Std.parseInt(args[0]));
        } else {
            new Main();
        }
    }

    public function new(?day:Int) {
        var today = Date.now();
        this.day = day == null ? today.getDate() : day;

        var funcMap:Array<AdventMakeFunc> = getFuncMap();

        funcMap[this.day - 1](getInput());
    }

    static macro function getFuncMap() {
        var srcPath = "./src/y2024";
        var days:Array<String> = [];

        for (dayFile in FileSystem.readDirectory(srcPath)) {
            var dayPath = Path.join([srcPath, dayFile]);
            var dayPattern = ~/^(Day\d{1,2})\.hx$/;
            if (!FileSystem.isDirectory(dayPath) && dayPattern.match(dayFile)) {
                days.push(dayPattern.matched(1));
            }
        }

        days.sort((a, b) -> a < b ? -1 : 1);
        var ret:Array<Expr> = [];
        for (day in days) {
            ret.push(macro y2024.$day.make);
        }

        return macro $a{ret};
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
