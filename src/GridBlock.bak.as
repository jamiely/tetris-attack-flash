class GridBlock extends Block {
	private var _grid: Grid;

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
		this.getView().block = this;
		
		this.getView().onPress = function() { 
			this.block.getGrid().selectBlock(this.block);
			//trace("Block location: " + this.block.getLocation().toString() +
				//" Grid size: " + this.block.getGrid().getSize().toString());
			
			var loc = this.block.getGridLocation();
			//trace("Block's grid loc: " + loc.toString());
			//trace(this.grid.getBlock(loc.x, loc.y - 1) == null ? "No block underneath: " + this.grid.getBlock(loc.x, loc.y - 1): "Block underneath");
			//trace(this.block.isInMidair() ? "In Midair" : "Not in midair");
		}
		this._droppedHeight = 0;
	}

	public function dropBlock(dropHeight: Number): Boolean {
		if(dropHeight == undefined) dropHeight = 1;

	//	for(var i = 1; i <= dropHeight; i++) {
			var location: Location = 
				new Location(this.getLocation().x, this.getLocation().y + dropHeight);

			if(not this.isInMidair(dropHeight)) {
			/*
				var gl = this.getGridLocation();
				
				if(gl.y != 0) {
					var newLocation = new Location(location.x, this.getGrid().getSize().height - this.getSize().height * gl.y);
					var block = this.getGrid().getBlock(gl.x, gl.y - 1);

					if(block != null && block != undefined && not block.hitTest(newLocation)) {
						//trace("******" + block + " *******" + (block.getLocation().y - this.getSize().height ));
						//this.setLocation(newLocation);
					}
				}*/
				return false;
			} else if(not this.isInBounds(location)) {
				setLocation(
					new Location(this.getLocation().x, this.getGrid().getSize().height - this.getSize().height));
				//this.setGridLocation(new Location(this.getGridLocation().x, 0)); // should be on bottom of grid
				return false;
			}

			this.setLocation(location);
			//trace("dropped");
			/*
			this._droppedHeight += dropHeight;
			
			if(this._droppedHeight >= this.getSize().height) { // it has dropped to a new grid position
				//this.setGridLocation(new Location(this.getGridLocation().x, this.getGridLocation().y--)); // should be on bottom of grid
				this._droppedHeight = 0;
			}*/
//		}
		return true;
	}

	public function isInBounds(location: Location): Boolean {
		var g: Grid = this.getGrid(), gs: Size = g.getSize(), gl: Location = g.getLocation();

		return gs.width + gl.x > location.x && location.x >= gl.x &&
			gs.height + gl.y > location.y && location.y >= gl.y;
	}

	public function isInMidair(dropHeight: Number): Boolean {	 // this has to be fixed later, must increment dropHeight
		if(dropHeight == undefined) dropHeight = 1;
		var grid: Grid = this.getGrid();
		var newLocations: Array = new Array();

		
		var location: Location = 
			new Location(this.getLocation().x, this.getLocation().y + dropHeight);

		//trace("new location: " + location);
/*
		// top right
		newLocations.push(new Location(location.x + this.getWidth(), location.y));

		// top left
		newLocations.push(new Location(location.x, location.y));
*/
		// bottom right
		newLocations.push(new Location(location.x + this.getWidth(), location.y + this.getHeight()));

		// bottom left
		newLocations.push(new Location(location.x, location.y + this.getHeight()));

		var gl = this.getGridLocation();

		if(gl.y == 0) return false; // block in bottom row, so it cannto be in midair

		var bl = this.getGridLocation(new Location(this.getLocation().x, this.getLocation().y + this.getSize().height + dropHeight));
		//trace("Block location: " + bl.toString());
		var block = grid.getBlock(bl.x, bl.y);
		
		for(var i = 0; i < newLocations.length; i++) 
			if(block.hitTest(newLocations[i])) return false;

		for(var y = 0; y < grid.getSizeInBlocks().height; y++) 
			for(var i = 0; i < newLocations.length; i++) {
				block = grid.getBlock(bl.x, y);
				//trace("testing block: " + block + " again this block: " + this);
				if(y != gl.y && block != null && block != undefined && block.hitTest(newLocations[i])) {
					
					return false;
				}
			}
		

//		for(var i = 0; i < newLocations.length; i++) 
			//if(grid.hitTest(newLocations[i])) return false;

		//trace("gridwidth: " + grid.getSizeInBlocks().width + " gridheight: " + grid.getSizeInBlocks().height);
/*
		var block: GridBlock;

		var x = this.getLocation().x;
//		for(var x = 0; x < grid.getSizeInBlocks().width; x++) {
			for(var y = 0; y < grid.getSizeInBlocks().height; y++) {
				block = grid.getBlock(x, y);
				if(block == null || block == undefined || (this.getGridLocation().x == x && this.getGridLocation().y == y)) {
					trace("block error");
				}	else {
					// test the new location of the block
					for(var i = 0; i < newLocations.length; i++)
						if(block.hitTest(newLocations[i]) || not this.isInBounds(newLocations[i]))
							return false;
					//trace("a: " + grid.getBlock(x, y).getLocation().toString() + " b:" + location.toString());
				}
			}
	//	}
	*/			
		//trace("Two");
		return true;
	}
	/*
	public function moveTo(location: Location): Boolean {
		var grid: Grid = this._grid;
		var newLocations: Array;

		// top left
		newLocations.push(location);

		// bottom right
		newLocations.push(new Location(location.x + this.getWidth(), location.y - this.getHeight()));

		// bottom left
		newLocations.push(new Location(location.x, location.y - this.getHeight()));

		// top right
		newLocations.push(new Location(location.x + this.getWidth(), location.y));

		for(var x = 0; x < grid.getSizeInBlocks().width; x++) 
			for(var y = 0; y < grid.getSizeInBlocks().width; y++)
				if(grid[x][y] != null) { // there is actually some block there
					for(var i = 0; i < newLocations.length; i++)
						if(grid[x][y] != this && grid[x][y].hitTest(newLocations)) // test the new location of the block
							return false;
				}

		this.setLocation(location);

		return true;
	}
	*/

	public function getGridLocation(location: Location): Location {
		var gs = this.getGrid().getSize(); // grid size
		var bs = this.getGrid().getBlockSize(); // block size
		var loc = location == undefined || location == null ? this.getLocation() : location;

		//trace("Get grid loc: " + loc);

		return new Location(Math.floor(loc.x / bs.width), Math.floor((gs.height - loc.y - 1) / bs.height));
	}
/*
	public function setGridLocation(location: Location): Void {
		this._gridLocation = location;
	}
*/
	public function isMoving(): Boolean {
		return this._isMoving || this.isInMidair();
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

	public function getGrid(): Grid {
		return this._grid;
	}

	public function toString(): String {
		return "[GridBlock (" + this.getGridLocation() + ", " + this.getLocation() + ")]";
	}
}