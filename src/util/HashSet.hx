package util;

import haxe.ds.HashMap;

@:forward(remove, exists)
abstract HashSet<T:{hashCode:() -> Int}>(HashMap<T, Bool>) {
    inline public function new() {
        this = new HashMap();
    }

    inline public function set(t:T) {
        this.set(t, true);
    }
}
