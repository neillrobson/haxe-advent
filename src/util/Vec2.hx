package util;

/**
 * Two-dimensional coordinate storage
 */
abstract Vec2(Vec2Data) from Vec2Data to Vec2Data {
	public var x(get, set):Int;
	public var y(get, set):Int;

	inline function get_x()
		return this.x;

	inline function set_x(x)
		return this.x = x;

	inline function get_y()
		return this.y;

	inline function set_y(y)
		return this.y = y;

	public inline function new(x:Int, y:Int) {
		this = new Vec2Data(x, y);
	}

	@:op(a + b)
	static inline function add(a:Vec2, b:Vec2):Vec2 {
		return new Vec2(a.x + b.x, a.y + b.y);
	}

	@:op(a - b)
	static inline function subtract(a:Vec2, b:Vec2):Vec2 {
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

	public inline function toString():String {
		return '< $x, $y >';
	}
}
