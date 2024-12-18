package util;

import haxe.Int64;

abstract Int64Map<T>(Map<Int, Map<Int, T>>) {
    public function new() {
        this = new Map<Int, Map<Int, T>>();
    }

    public inline function set(key:Int64, value:T) {
        var low = key.low;
        var high = key.high;

        var highMap = this[low];
        if (highMap == null) {
            highMap = new Map<Int, T>();
            this[low] = highMap;
        }

        highMap[high] = value;
    }

    public inline function get(key:Int64):Null<T> {
        var low = key.low;
        var high = key.high;

        var highMap = this[low];

        return highMap != null ? highMap[high] : null;
    }

    public inline function remove(key:Int64) {
        var low = key.low;
        var high = key.high;

        var highMap = this[low];

        return if (highMap != null) {
            var removed = highMap.remove(high);

            var isHighMapEmpty = !highMap.keys().hasNext();
            if (isHighMapEmpty)
                this.remove(low);

            removed;
        } else {
            false;
        }
    }

    public inline function keyValueIterator():KeyValueIterator<Int64, T> {
        return new Int64MapIterator(this.keyValueIterator());
    }
}

class DummyIterator {
    public inline function new() {}

    public inline function hasNext() {
        return false;
    }

    public inline function next() {
        return null;
    }
}

class Int64MapIterator<T> {
    var outer:KeyValueIterator<Int, Map<Int, T>>;
    var inner:KeyValueIterator<Int, T> = new DummyIterator();
    var low:Null<Int> = null;

    public inline function new(outer:KeyValueIterator<Int, Map<Int, T>>) {
        this.outer = outer;
    }

    public inline function hasNext():Bool {
        while (!inner.hasNext() && outer.hasNext()) {
            var kv = outer.next();
            low = kv.key;
            inner = kv.value.keyValueIterator();
        }

        return inner.hasNext();
    }

    public inline function next():{key:Int64, value:T} {
        while (!inner.hasNext() && outer.hasNext()) {
            var kv = outer.next();
            low = kv.key;
            inner = kv.value.keyValueIterator();
        }

        if (!inner.hasNext())
            return null;

        var kv = inner.next();
        var high = kv.key;

        return {
            key: Int64.make(high, low),
            value: kv.value
        }
    }
}
