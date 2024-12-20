package util;

using haxe.Int64;

/**
 * Two-dimensional coordinate storage
 */
@:forward
abstract Vec2Big(Vec2BigData) from Vec2BigData to Vec2BigData {
    public inline function new(x:Int64, y:Int64) {
        this = new Vec2BigData(x, y);
    }

    @:op(a + b)
    static inline function add(a:Vec2Big, b:Vec2Big):Vec2Big {
        return new Vec2Big(a.x + b.x, a.y + b.y);
    }

    @:op(a + b) @:commutative
    static inline function addScalar(a:Vec2Big, b:Int64):Vec2Big {
        return new Vec2Big(a.x + b, a.y + b);
    }

    @:op(a - b)
    static inline function subtract(a:Vec2Big, b:Vec2Big) { // type hint for return value causes error
        return new Vec2Big(a.x - b.x, a.y - b.y);
    }

    @:op(a * b) @:commutative
    static inline function multiplyScalar(a:Vec2Big, b:Int64):Vec2Big {
        return new Vec2Big(a.x * b, a.y * b);
    }

    @:op(a == b)
    static inline function equal(a:Vec2Big, b:Vec2Big):Bool {
        return a.x == b.x && a.y == b.y;
    }
}

class Vec2BigData {
    public var x:Int64;
    public var y:Int64;

    public inline function new(x:Int64, y:Int64) {
        this.x = x;
        this.y = y;
    }

    public inline function hashCode():Int64 {
        var ret:Int64 = 0;
        ret = (ret * 397) ^ this.x;
        ret = (ret * 397) ^ this.y;
        return ret;
    }

    public function equals(that:Vec2BigData):Bool {
        return this.x == that.x && this.y == that.y;
    }

    public inline function toString():String {
        return '< ${x.toStr()}, ${y.toStr()} >';
    }
}
