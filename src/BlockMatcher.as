/**
 * BlockMatcher.as
 * Finds matches and removes them.
 */
class BlockMatcher extends MovieClip implements Executable {
	var _subjectBlock: GridBlock; 
	var _grid: Grid;

	// directions to search
	var _north = 0,
		_east = 1,
		_south = 2,
		_west = 3,
		_minimumMatch = 3; // 3 block match minimum

	var _horizontal: Array,
		_vertical: Array;

	public function initialize(block: GridBlock) {
		this._horizontal = new Array();
		this._vertical = new Array();
		this._subjectBlock = block;
	}

	public function execute(Void): Void {
		trace("Starting block matcher");
		this.onEnterFrame = this.findMatches;
	}

	public function match(gridLoc: Location, direction: Number): Boolean {
		var block = this._grid.getBlock(gridLoc.x, gridLoc.y);
		if(Common.isInvalid(block)) return false;
		if(this._subjectBlock.getBlockType() == block.getBlockType()) {
			switch(direction) {
				case this._north: case this._south: 
					this._vertical.push(block); // add block to matched
				case this._west: case this._east:
					this._horizontal.push(block); // add block to matched
				default:
					trace("BlockMatcher.as: Unrecognized direction type");
			}
		} else {
			return false;
		}

		switch(direction) {
			case this._north: 
				return this.match(new Location(gridLoc.x, gridLoc.y-1), direction);
			case this._south:
				return this.match(new Location(gridLoc.x, gridLoc.y+1), direction);
			case this._west:
				return this.match(new Location(gridLoc.x-1, gridLoc.y), direction);
			case this._east:
				return this.match(new Location(gridLoc.x+1, gridLoc.y), direction);
		}

		return true;
	}

	public function findMatches() {
		if(Common.isInvalid(this._subjectBlock)) return;

		var loc = this._subjectBlock.getGridLocation(),
			x = loc.x,
			y = loc.y;
		
		match(new Location(x, y-1), this._north);
		match(new Location(x, y+1), this._south);
		match(new Location(x+1, y), this._east);
		match(new Location(x-1, y), this._west);

		if(this._horizontal.length >= this._minimumMatch) {
			// attach new BlockRemover mc
			var depth = this._parent.getNextHighestDepth();
			var br = this._parent.attachMovie("BlockRemover", "blockremover" + depth, depth);

			br.initialize(this._horizontal);
		}

		if(this._vertical.length >= this._minimumMatch) {
			// attach new BlockRemover mc
			// add 
			var depth = this._parent.getNextHighestDepth();
			var br = this._parent.attachMovie("BlockRemover", "blockremover" + depth, depth);
			
			br.initialize(this._vertical);
		}
		
		// removes movieclip from its parent
		trace("Removing BlockMatcher");
		this.removeMovieClip();
	}
}
				