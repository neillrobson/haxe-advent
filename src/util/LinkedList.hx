package util;

class LinkedList<T> {
	private final head:Node<T>;
	private final tail:Node<T>;

	public function new() {
		head = new Node(null, null, null);
		tail = new Node(null, null, null);
		head.next = tail;
		tail.prev = head;
	}

	/**
	 * Append an item to the list.
	 * @param item
	 */
	public function add(item:T) {
		var n = new Node(item, tail.prev, tail);
		tail.prev.next = n;
		tail.prev = n;
	}

	/**
	 * Prepend an item to the list.
	 * @param item
	 */
	public function push(item:T) {
		var n = new Node(item, head, head.next);
		head.next.prev = n;
		head.next = n;
	}

	public function firstNode() {
		if (head.next.item != null)
			return head.next;

		return null;
	}

	public function lastNode() {
		if (tail.prev.item != null)
			return tail.prev;

		return null;
	}

	public function remove(node:Node<T>) {
		node.next.prev = node.prev;
		node.prev.next = node.next;
		node.prev = null;
		node.next = null;
	}

	public function splice(node:Node<T>, next:Node<T>) {
		node.prev = next.prev;
		node.next = next;
		node.prev.next = node;
		node.next.prev = node;
	}
}

class Node<T> {
	public var item:T;
	public var prev:Node<T>;
	public var next:Node<T>;

	public function new(item:T, prev:Node<T>, next:Node<T>) {
		this.item = item;
		this.prev = prev;
		this.next = next;
	}
}
