class GridBlock extends Block {
	private var _grid: Grid;

	private var _blockAbove: GridBlock;
	private var _blockBelow: GridBlock;

	/**
	 * Location in the grid measured in terms
	 * of blocks.
	 */
	private var _gridLocation: Location;

	/**
	 * set to true if moving.  If a block is moving
	 * it's grid location may be in the progress of 
	 * changing.
	 */
	private var _isMoving: Boolean; 

	/**
	 * Pixels block has fallen from its position in the grid.
	 * should be reset whenever it has fallen to a new position in the grid.
	 */
	private var _droppedHeight: Number = 0;

	public function GridBlock(parent: MovieClip, mcLinkageName: String, blockType: Number) {
		super(parent, mcLinkageName, blockType);

		this._blockAbove = null;
		this._blockBelow = null;

		this.getView().block = this;
		
		this.getView().onPress = function() { 
			if(not this.block.isFalling())
				this.block.getGrid().selectBlock(this.block);
		}
		this._droppedHeight = 0;

		this.setIsMoving(false);
	}

	/**
	 * On press should be attached to this control's view.
	 * As such, the variables referenced in the function
	 * refer to the view's variables, and not this object's
	 
	public function onPress() { 
		if(not this.block.isFalling())
			this.block.getGrid().selectBlock(this.block);
	}
	*/


	public function isInBounds(location: Location): Boolean {
		var g: Grid = this.getGrid(), gs: Size = g.getSize(), gl: Location = g.getLocation();

		return gs.width - this.getWidth() >= location.x && location.x >= 0 &&
			gs.height - this.getHeight() >= location.y && location.y >= 0;
		//return gs.width - this.getWidth() >= location.x && 0 >= gl.x &&
		//	gs.height - this.getHeight() >= location.y && 0 >= gl.y;
	}

	// deprecated
	public function isInMidair(dropHeight: Number): Boolean {	 // this has to be fixed later, must increment dropHeight
		return true;
	}

	public function dropBlock(amount: Number, fall: Boolean) {
		if(not Common.isValid(amount)) amount = 1;
		var didFall = false;

		if(Common.isInvalid(fall)) fall = false;

		var rtn = false;

		if(!this.isMoving() && (fall || isFalling())) {
			// attempts to optimize the behavior of this 
			// function by dropping blocks more than 1 pixel
			// var distance = Common.isValid(this.getBlockBelow()) ? 
			// this.getBlockBelow().getLocation().y - (this.getLocation().y + this.getHeight()) : 
				//1;

		//	amount = distance < amount ? distance : amount;
		
			this.setLocation(new Location(Math.floor(this.getLocation().x), this.getLocation().y + 1));
			//trace(this.getLocation());
			if(this.getLocation().y + this.getHeight() == this.getGrid().getHeight() || this.getLocation().y % this.getHeight() == 0) {
				this.setGridLocation(
					new Location(
						this.getGridLocation().x, 
						Math.floor((this.getLocation().y + 1) / this.getHeight())
					)
				);
			} 
			didFall = true;
			rtn = true;
		}

		if(Common.isValid(this.getBlockAbove())) 
			this.getBlockAbove().dropBlock(didFall); // drop block above

		return rtn;
	}

	public function getGridLocation(location: Location): Location {
		return this._gridLocation;
	}

	public function isFalling(): Boolean {
		return this.getGridLocation().y != this.getGrid().getHeightInBlocks()-1 && // no block on bottom row can be falling
			(//Common.isInvalid(this.getBlockBelow()) ||  // there is no block below
			// there is room between this block and the block below
			this.getLocation().y + this.getHeight() < this.getBlockBelow().getLocation().y ||
			this.getBlockBelow().isFalling()); // the block below is falling;
	}

	public function setGridLocation(location: Location): Void {
		if(Common.isInvalid(location)) return;

		var gl = this.getGridLocation();
		if(this.getGrid().getBlock(gl.x, gl.y) == this) 
			this.getGrid().setBlock(gl.x, gl.y, null);
		this.getGrid().setBlock(location.x, location.y, this);

		//trace("setGridLocation start");
		var below = this.getBlockBelow(),
				above = this.getBlockAbove();
		if(location.x != this.getGridLocation().x) { // different x position
			//trace("DIFFERENT X POSITION");

			if(Common.isValid(above))
				above.setBlockBelow(below); // remove from previous column
			else below.setBlockAbove(null);

			//trace("GEtting highest loweest block");
			// insert into new column
			var g = this.getGrid();

			//trace("Location: " + location);
			above = g.getNextHighestBlock(location);
			//trace("Above: " + above);
			below = g.getNextLowestBlock(location);
			//trace("Below: " + below);

			//trace("Above below");
			this.setBlockAbove(above);
			this.setBlockBelow(below);
		}

		//trace("Grid loc");
		this._gridLocation = location;

		//trace("Update");
		this.updateDebug();

		this.getGrid().setBlock(location.x, location.y, this);
		//trace("setGridLocation end");
	}

	public function updateDebug(): Void {
		var below = this.getBlockBelow(),
				above = this.getBlockAbove(),
				location = this.getGridLocation();

		this.getView().id.text = 
			(Common.isValid(above) ? String(above.getGridLocation().x + above.getGridLocation().y * 10) : "?") + "\n" + 
			String(location.x + location.y * 10) + "\n" + 
			(Common.isValid(below) ? String(below.getGridLocation().x + below.getGridLocation().y * 10) : "?");
	}

	public function isMoving(): Boolean {
		return this._isMoving;
	}

	public function getIsMoving(): Boolean {
		return this.isMoving();
	}

	public function setIsMoving(value: Boolean) {
		this._isMoving = value;
	}

	public function setGrid(value: Grid) {
		this._grid = value;
		this.getView().grid = this.getGrid();
	}

	public function setLocation(location: Location) {
		super.setLocation(location);
		//var gl = this.getGridLocation();
		//this.getGrid().setBlock(gl.x, gl.y, this);
	}

	public function getGrid(): Grid {
		return this._grid;
	}

	public function toString(): String {
		return "[GridBlock (" + this.getGridLocation() + ", " + this.getLocation() + ")]";
	}

	public function getBlockAbove(): GridBlock {
		return this._blockAbove;
	}

	public function setBlockAbove(block: GridBlock): Void {
		this._blockAbove = block;
		block._blockBelow = this;
	}

	public function getBlockBelow(): GridBlock {
		return this._blockBelow;
	}

	public function setBlockBelow(block: GridBlock): Void {
		this._blockBelow = block;
		block._blockAbove = this;
	}
}
