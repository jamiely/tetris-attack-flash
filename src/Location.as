class Location {
	public var x: Number;
	public var y: Number;
	
	public function Location(x: Number, y: Number) {
		this.x = x;
		this.y = y;
	}

	public function toString(): String {
		return "(" + this.x + ", " + this.y + ")";
	}

	public function equals(location: Location) {
		return this.x == location.x && 
			this.y == location.y;
	}

	public function copy(): Location {
		return new Location(this.x, this.y);
	}
}