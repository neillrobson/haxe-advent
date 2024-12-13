package util;

class Heap<T> {
    var data:Array<T> = [];
    var comparator:T->T->Int;

    public function new(comparator) {
        this.comparator = comparator;
    }

    public function push(x:T) {
        var i = data.push(x) - 1;
        var j = (i - 1) >> 1;

        while (i > 0 && comparator(data[i], data[j]) < 0) {
            swap(data[i], data[j]);
            i = j;
            j = (i - 1) >> 1;
        }
    }

    public function pop():T {
        if (data.length == 0)
            return null;

        if (data.length == 1)
            return data.pop();

        var ret = data[0];
        data[0] = data.pop();

        var i = 0;
        while (true) {
            var l = 2 * i + 1;
            var r = 2 * i + 2;
            if (l < data.length && comparator(data[l], data[i]) < 0) {
                swap(data[l], data[i]);
                i = l;
            } else if (r < data.length && comparator(data[r], data[i]) < 0) {
                swap(data[r], data[i]);
                i = r;
            } else {
                break;
            }
        }

        return ret;
    }

    public function peek():T {
        if (data.length == 0)
            return null;

        return data[0];
    }

    public function length():Int {
        return data.length;
    }

    macro static function swap(a, b) {
        return macro {var v = $a; $a = $b; $b = v;};
    }
}
