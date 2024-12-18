package util;

using Lambda;

typedef Comparable<T> = {
    public function hashCode():Int;
    public function equals(t:T):Bool;
}

class HashSet<T:Comparable<T>> {
    public var length(default, null):Int = 0;

    var map:Array<Array<T>>;
    var size:Int;

    public function new(size = 10) {
        this.size = size;
        clear();
    }

    public function set(t:T) {
        var hash = t.hashCode();
        var i = (hash < 0 ? -hash : hash) % size;
        for (e in map[i])
            if (e.equals(t))
                return false;

        map[i].push(t);
        ++length;
        return true;
    }

    public function remove(t:T) {
        var hash = t.hashCode();
        var i = (hash < 0 ? -hash : hash) % size;
        for (e in map[i])
            if (e.equals(t)) {
                map[i].remove(e);
                --length;
                return true;
            }

        return false;
    }

    public function values() {
        return map.flatten();
    }

    public function clear() {
        map = [for (_ in 0...size) []];
        length = 0;
    }
}
