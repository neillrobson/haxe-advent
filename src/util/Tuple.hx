package util;

import haxe.ds.Vector;

abstract Tuple(Vector<Int>) {
    inline public function new(v:Vector<Int>) {
        this = v;
    }

    public inline function hashCode():Int {
        var ret = 0;

        for (i in this)
            ret = (ret * 397) ^ i;

        return ret;
    }
}
