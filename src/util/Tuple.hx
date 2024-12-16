package util;

import haxe.ds.Vector;

@:forward
abstract Tuple(TupleData) {
    inline public function new(a:Array<Int>) {
        this = new TupleData(Vector.fromArrayCopy(a));
    }

    @:from
    static public function fromArray(a:Array<Int>) {
        return new Tuple(a);
    }

    @:op([])
    public function get(i:Int) {
        return this.v[i];
    }

    @:op([])
    public function set(i:Int, val:Int) {
        return this.v[i] = val;
    }
}

class TupleData {
    public var v:Vector<Int>;

    public inline function new(v:Vector<Int>) {
        this.v = v;
    }

    public inline function hashCode():Int {
        var ret = 0;

        for (i in v)
            ret = (ret * 397) ^ i;

        return ret;
    }

    public inline function equals(that:Tuple):Bool {
        for (i in 0...v.length)
            if (v[i] != that[i])
                return false;

        return true;
    }
}
