class Grid extends Control {
	/**
	 * The size of a single block,
	 * trash blocks are made of single blocks
	 */
	private var _blockSize: Size;

	/**
	 * The size of the grid in blocks.
	 */
	private var _sizeInBlocks: Size;

	/**
	 * An array of GridBlocks
	 */
	private var _grid: Array;

	/**
	 * Selected blocks.
	 */
	private var _selectedBlocks: Array;

	private var _blockFactory: BlockFactory;

	private var _gravity; // Gravity object

	public function Grid(parent: MovieClip, mcLinkageName: String, blockSize: Size, sizeInBlocks: Size) {
		//trace("Creating Grid");
		this.setParent(parent); // parent
		//trace("Parent: " + this.getParent());

		this._selectedBlocks = new Array();

		var depth:Number = this._parent.getNextHighestDepth();

		// attach the movie clip representing the block to its _parent
		this.setName("grid" + String(depth));
		this.setView(this._parent.attachMovie(mcLinkageName, this.getName(), depth));
		
		this.setBlockSize(blockSize);
		this.setSizeInBlocks(sizeInBlocks); // should clone sizeInBlocks instead

		this.setSize(new Size(blockSize.width * sizeInBlocks.width, 
			blockSize.height * sizeInBlocks.height));

		//trace("Grid size: " + this.getSize().toString());
		this.setLocation(new Location(0, 0));

		this.initializeGrid(sizeInBlocks);
		this._blockFactory = new BlockFactory(this.getView());

		//drawBorder();

		depth = this._parent.getNextHighestDepth();
		this._gravity = this.getView().attachMovie("Gravity", "gravity" + String(depth), depth);
		this._gravity.initialize(this, 5);  // gravity at .5 pixel per frame

		//trace("Created Grid");
	}

	public function drawBorder() {
		this.getView().createEmptyMovieClip("border", 0);
		with(this.getView().border) {
			lineStyle(1, 0x000000, 100);
			moveTo(this.getLocation().x, this.getLocation().y);
			lineTo(this.getLocation().x + this.getSize().width, this.getLocation().y);
			lineTo(this.getLocation().x + this.getSize().width, this.getLocation().y + this.getSize().height);
			lineTo(this.getLocation().x, this.getLocation().y + this.getSize().height);
			lineTo(this.getLocation().x, this.getLocation().y);
		}
	}

	/**
	 * Zeros and populates grid.
	 * @return The number of blocks added.
	 */
	public function populateGrid(height: Number, density: Number): Number {
		if(density < 0 || density > 1 || 
			height > this.getSizeInBlocks() || height < 1) 
			return 0;

		this.zeroGrid(); // remove all blocks
		var counter: Number = 0;

		var x: Number, y: Number; 
		
		for(y = this.getHeightInBlocks()-1; y >= this.getHeightInBlocks()-height; y--) { 
			for(x = 0; x < this.getWidthInBlocks(); x++) { 
				if(y != this.getHeightInBlocks()-1 && Math.random() > density) continue;

				var block: GridBlock;

				block = this._blockFactory.getRandomBlock();
				block.setSize(this.getBlockSize());
				block.setLocation(
					new Location(x * this.getBlockSize().width, 
					y * this.getBlockSize().height));

				block.setGrid(this);
				
				block.setGridLocation(new Location(x, y));

				if(block != null) counter++;
				
				this._grid[x][y] = block;
				
			}
		}

		// set relative positions of blocks.
		// right now, only setting block above and
		// block below to make falling blocks easier, 
		// but maybe set block to the left
		// and block to the right

		for(y = this.getHeightInBlocks()-1; y >= this.getHeightInBlocks()-height; y--) { 
			for(x = 0; x < this.getWidthInBlocks(); x++) { 
				this._grid[x][y].setBlockAbove(this.getNextHighestBlock(this._grid[x][y].getGridLocation()));
				this._grid[x][y].setBlockBelow(this.getNextLowestBlock(this._grid[x][y].getGridLocation()));
			}
		}

		this._gravity.populateFallingList();

		return counter;
	}

	/**
	 * "Higher" blocks are at indicies where y is lower.
	 */
	private function getNextHighestBlock(location: Location): GridBlock { 
		if(Common.isInvalid(location)) return null;
		var block = null;
		for(var y = location.y - 1; y >= 0; y--) {
			block = this.getBlock(location.x, y);
			if(Common.isValid(block)) return block;
		}
		return null;
	}
		
	/**
	 * "Lower" blocks are at indicies where y is lower.
	 */			
	private function getNextLowestBlock(location: Location): GridBlock { 
		if(Common.isInvalid(location)) return null;
		var block = null;
		for(var y = location.y + 1; y < this.getHeightInBlocks(); y++) {
			block = this.getBlock(location.x, y);
			if(Common.isValid(block)) return block;
		}
		return null;
	}


	private function initializeGrid(): Boolean {
		var sb: Size = this.getSizeInBlocks();
		if(sb == null) return false;

		this._grid = new Array(sb.width);		
		for(var i = 0; i < sb.width; i++) 
			this._grid[i] = new Array(sb.height);
		
		this.zeroGrid();

		return true;
	}

	private function zeroGrid(): Void {
		var sb: Size = this.getSizeInBlocks(); 
		for(var i = 0; i < sb.width; i++) {
			for(var j = 0; j < sb.height; j++) {
				if(Common.isValid(this._grid[i][j])) this._grid.destroy(); // destroy if exists
				this._grid[i][j] = null; // initialize the grid
			}
		}
	}

	/**

	public function isAvailable(locationInBlocks: Location): Boolean {
		var sb: Size = this.getSizeInBlocks();
		return 
			// test bounds
			sb.width > locationInBlocks.x && 0 <= locationInBlocks.x &&
			sb.height > locationInBlocks.y && 0 <= locationInBlocks.y && 

			// test grid
			this._grid[locationInBlocks.x][locationInBlocks.y] == null;
	}	

	public function isAvailableExact(location: Location): Boolean {
		var sb: Size = this.getSizeInBlocks(),
			x: Number = location.x, 
			y: Number = location.y,
			blockX: Number = location.x / sb.width,
			blockY: Number = location.y / sb.height;
		
		return 
			// test bounds
			sb.width > blockX && 0 <= blockX &&
			sb.height > blockY && 0 <= blockY && 

			// test grid
			this._grid[location.x][location.y] == null;
	}	*/

	public function getSizeInBlocks(): Size {
		return this._sizeInBlocks;
	}

	public function getHeightInBlocks(): Number {
		return this.getSizeInBlocks().height;
	}

	public function getWidthInBlocks(): Number {
		return this.getSizeInBlocks().width;
	}

	public function setBlockSize(blockSize: Size): Void {
		this._blockSize = blockSize;
	}

	public function getBlockSize(): Size {
		return this._blockSize;
	}

	public function setSizeInBlocks(size: Size): Void {
		this._sizeInBlocks = size;
	}

/*
	public function dropAllBlocks(dropHeight: Number): Void {
		// iterate from bottom to top

			var block;
			for(var x = 0; x < this.getWidthInBlocks(); x++) { 
				block = Common.isValid(this._grid[x][0]) ? 
					this._grid[x][0] : 
					this.getNextHighestBlock(new Location(x, 0));

				if(block != null)
					block.dropBlock(dropHeight);
			}
	}
*/

	// schedule blocks for swapping
	public function swapBlocks(a: GridBlock, b: GridBlock): Boolean {
		// cannot swap blocks that are moving
		if(a.isMoving() || b.isMoving()) return false; 
		//trace("Swap blocks");

		var depth:Number = this.getView().getNextHighestDepth();

		// attach the movie clip representing the block to its _parent
		var bs = this.getView().attachMovie("BlockSwitcher", "blockSwitcher" + String(depth), depth);

		bs.initialize(a, b, 5); 

		depth++; // depth of blockswitcher
		var bm = this.getView().attachMovie("BlockMatcher", "blockMatcher" + String(depth), depth); // blockMatcher

		bm.initialize(a);	
		bs.addOnSwitchHandler(bm); // block matching will execute when switch is complete
		

		// if the block types are the same, there is no need for an
		// additional blockmatcher.
		if(a.getBlockType() != b.getBlockType()) {
			depth++;
			bm = this.getView().attachMovie("BlockMatcher", "blockMatcher" + String(depth), depth); // blockMatcher
			bm.initialize(b);
			bs.addOnSwitchHandler(bm); // block matching will execute when switch is complete
		}

		

		return true;
	}

	
	public function getBlockToLeft(block: GridBlock): GridBlock {
		var gl = block.getGridLocation();
		return this.getBlock(gl.x - 1, gl.y);
	}

	public function getBlockToRight(block: GridBlock): GridBlock {
		var gl = block.getGridLocation();
		return this.getBlock(gl.x + 1, gl.y);
	}

	/**
	 * Select block causes blocks to be moved.  
	 */
	public function selectBlock(block: GridBlock): Void {
		// do not move nulls or blocks that are already moving
		if(Common.isInvalid(block) || block.isMoving()) return;

		var neighbor = this.getBlockToRight(block);

		if(Common.isInvalid(neighbor)) {
			// perform hit test
			var gl = block.getGridLocation();
			if(gl.x == this.getWidthInBlocks() - 1) return;
			var nloc = new Location(gl.x + 1, gl.y);
			neighbor = this.getNextHighestBlock(nloc);

			var loc = block.getLocation();
			nloc = neighbor.getGridLocation(); // get true grid location
			//trace("Nloc: " + nloc.y + " gl: " + (gl.y - 1));
			if(nloc.y == gl.y - 1) { // one grid location higher than current block
				//trace("Possible collision");
				if(neighbor.hitTest(new Location(loc.x + block.getWidth() + 5, loc.y - 5))) {// collision!
					//trace("Collision");
					return;
				}
			}
			neighbor = null;
		}

		if(Common.isValid(neighbor) && neighbor.isFalling()) { 
			//trace("Cannot swap neighbor is falling");
			return;
		}
			
		
		if(not this.swapBlocks(block, neighbor)) 
			trace("BLOCKS ARE MOVING");
	}

	public function getBlock(x: Number, y: Number): GridBlock {
		//trace("get block: " + this._grid[x][y]);
		return this._grid[x][y];
	}

	public function setBlock(x: Number, y: Number, b: GridBlock): Void {
		if(x >= this.getWidthInBlocks() || x < 0 || y >= this.getHeightInBlocks() || y < 0) return;
		this._grid[x][y] = b;
	}

	public function getBlockByLocation(loc: Location): GridBlock {
		return this._grid[loc.x][loc.y];
	}

	public function getGravity(): Gravity {
		return this._gravity;
	}

	public function getGridLocation(location: Location): Location {
		var gs = this.getSize(); // grid size
		var bs = this.getBlockSize(); // block size
		var loc = location;
		return new Location(Math.floor(loc.x / bs.width), Math.floor(loc.y + 1 / bs.height));
	}

	public function addNewRow(): Number {
		var counter = 0;
		var sib = this.getSizeInBlocks();
		var y = sib.height;

		var bwidth = this.getBlockSize().width,
			bheight = this.getBlockSize().height;

		sib = new Size(sib.width, sib.height + 1);
		this.setSizeInBlocks(sib);
		this.setSize(new Size(sib.width * bwidth, sib.height * bheight));

		for(var x = 0; x < this.getWidthInBlocks(); x++) {
			var block = this._blockFactory.getRandomBlock();

			if(Common.isInvalid(block)) return counter;
							
			this._grid[x].push(block);

			block.setSize(this.getBlockSize());
			block.setLocation(new Location(x * bwidth, y * bheight));

			block.setGrid(this);
				
			block.setGridLocation(new Location(x, y));

			counter++;
				
		}
	}
	public function start(): Void {
		this.getView().inc = 0;
		this.getView().grid = this;
		this.getView().incAmount = 0.25;

		this.getView().onEnterFrame = function() { 
			this._y -= this.incAmount;
			this.inc += this.incAmount;
			if(this.inc + this.incAmount > this.grid.getBlockSize().height) {
				this.grid.addNewRow();
				this.inc = 0;
			}
		}
	}

	public function stop(): Void {
		this.getView().onEnterFrame = undefined;
	}
}