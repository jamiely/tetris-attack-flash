class Control {
	/**
	 * The parent movieclip to attach block movieclips to.
	 */
	private var _parent: MovieClip;

	/**
	 * The movieclip representing the movieclip block.
	 */
	private var _view: MovieClip;

	/**
	 * The top left corner of the block.
	 */
	private var _location: Location;

	/**
	 * The width and height of the block.
	 */
	private var _size: Size;

	private var _name: String;

	public function Control() {
		this.initializeControl();
	}

	public function initializeControl(): Void {
		this.setParent(null);
		this.setView(null);
		this.setLocation(new Location(0, 0));
		this.setSize(new Size(10, 10)); // should be zero?
	}

	public function getView(): MovieClip {
		return this._view;
	}

	public function setView(view: MovieClip): Void {
		this._view = view;
	}

	public function getParent(): MovieClip {
		return this._parent;
	}

	public function setParent(parent: MovieClip): Void {
		this._parent = parent;
	}

	public function getSize(): Size {
		return this._size;
	}

	public function setSize(size: Size): Void {
		this._size = size;
//		this.getView()._width = size.width;
//		this.getView()._height = size.height;
	}

	public function getLocation(): Location {
		return this._location;
	}

	public function setLocation(location: Location): Void {
		this._location = location;
		this.getView()._x = location.x;
		this.getView()._y = location.y;
	}

	public function getHeight(): Number {
		return this._size.height;
	}

	public function getWidth(): Number {
		return this._size.width;
	}

	public function getTop(): Number {
		return this._location.x;
	}

	public function getLeft(): Number {
		return this._location.y;
	}

	public function hitTest(location: Location): Boolean {
		var hisX: Number = location.x,
			hisY: Number = location.y,
			myX: Number = this.getLocation().x,
			myY: Number = this.getLocation().y,
			height: Number = this.getSize().height,
			width: Number = this.getSize().width;

		return myX < hisX && myX + width > hisX &&
			myY < hisY && myY + height > hisY;
	}

	public function destroy(): Void {
		this.getView().removeMovieClip();
	}

	public function getName(): String {
		return this._name;
	}

	public function setName(name: String): Void {
		this._name = name;
	}
}