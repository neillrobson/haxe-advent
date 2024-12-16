import haxe.Exception;
import haxe.io.Path;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.Http;
import sys.io.File;

using tink.CoreApi;

typedef AdventMakeFunc = String->Void;

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

        getInput().handle(funcMap[this.day - 1]);
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

        days.sort((a, b) -> {
            var an = Std.parseInt(a.substr(3));
            var bn = Std.parseInt(b.substr(3));

            return an - bn;
        });
        var ret:Array<Expr> = [];
        for (day in days) {
            ret.push(macro y2024.$day.make);
        }

        return macro $a{ret};
    }

    function getInput():Future<String> {
        if (!FileSystem.exists("./cache")) {
            FileSystem.createDirectory("./cache");
        }

        var cachePath = './cache/$year';
        if (!FileSystem.exists(cachePath)) {
            FileSystem.createDirectory(cachePath);
        }

        var cacheFile = '$cachePath/$day.txt';
        if (FileSystem.exists(cacheFile)) {
            return Future.sync(File.getContent(cacheFile));
        }

        var USERAGENT = File.getContent("./secrets/useragent");
        var COOKIE = File.getContent("./secrets/session");

        return Future.irreversible(f -> {
            Sys.println('Retrieving data from server (2024 day $day)');
            var h = new Http('https://adventofcode.com/2024/day/$day/input');
            h.addHeader("User-Agent", USERAGENT);
            h.addHeader("Cookie", 'session=$COOKIE');
            h.onData = d -> {
                File.saveContent(cacheFile, d);
                f(d);
            }
            h.onError = e -> throw new Exception('HTTP error: $e');
            h.request();
        });
    }
}
