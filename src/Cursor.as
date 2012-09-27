class Cursor extends MovieClip {
	private var _grid: Grid;
	private var _blockSize: Size;
	private var _blockWidth: Number,
		_blockHeight: Number;

	private var _initialized: Boolean = false;

	public function initialize(grid: Grid): Void {
		this._grid = grid;
		this._blockSize = grid.getBlockSize();

		this._blockWidth = this._blockSize.width;
		this._blockHeight = this._blockSize.height;

		this._initialized = true;

		trace("Cursor initialized");
	}

/*
	public function OnEnterFrame(): Void {
		if(not this._initialized) return;

		this._x = Math.floor((this._x + (this._width / 4)) / this._blockWidth);
		this._y = Math.floor((this._y - (this._height / 2)) / this._blockHeight);
	}
*/
}