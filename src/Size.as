class Size {
	public var width: Number;
	public var height: Number;
	
	public function Size(width: Number, height: Number) {
		this.width = width;
		this.height = height;
	}

	public function equals(size: Size) {
		return this.width == size.width &&
			this.height == size.height;
	}

	public function toString(): String {
		return this.width + " x " + this.height;
	}
}