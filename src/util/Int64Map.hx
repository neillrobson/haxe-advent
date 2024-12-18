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
}
