package util;

/**
 * Two-dimensional coordinate storage
 */
@:forward
abstract Vec2(Vec2Data) from Vec2Data to Vec2Data {
    public inline function new(x:Int, y:Int) {
        this = new Vec2Data(x, y);
    }

    @:op(a + b)
    static inline function add(a:Vec2, b:Vec2):Vec2 {
        return new Vec2(a.x + b.x, a.y + b.y);
    }

    @:op(a + b) @:commutative
    static inline function addScalar(a:Vec2, b:Int):Vec2 {
        return new Vec2(a.x + b, a.y + b);
    }

    @:op(a - b)
    static inline function subtract(a:Vec2, b:Vec2) { // type hint for return value causes error
        return new Vec2(a.x - b.x, a.y - b.y);
    }

    @:op(a * b) @:commutative
    static inline function multiplyScalar(a:Vec2, b:Int):Vec2 {
        return new Vec2(a.x * b, a.y * b);
    }

    @:op(a == b)
    static inline function equal(a:Vec2, b:Vec2):Bool {
        return a.x == b.x && a.y == b.y;
    }
}

class Vec2Data {
    public var x:Int;
    public var y:Int;

    public inline function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }

    public inline function hashCode():Int {
        var ret = 0;
        ret = (ret * 397) ^ this.x;
        ret = (ret * 397) ^ this.y;
        return ret;
    }

    public function equals(that:Vec2Data):Bool {
        return this.x == that.x && this.y == that.y;
    }

    public inline function toString():String {
        return '< $x, $y >';
    }
}
