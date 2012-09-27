/**
 * This class applies gravity to objects.
 */

class Gravity extends MovieClip {
	/**
	 * Falling blocks.
	 */
	private var _fb: Array;

	private var _counter: Number = 0;

	private var _grid: Grid = null;
	private var _ppf: Number = 1;

	public var _hasBeenInitialized: Boolean = false;
	private var _isOn: Boolean = false;

	public function start(): Void { 
		this._isOn = true;
		this.onEnterFrame = this.applyGravity;
	}

	public function stop(): Void {
		this._isOn = false;
		this.onEnterFrame = null;
	}

	public function isOn(): Boolean {
		return this._isOn;
	}

	public function initialize(grid: Grid, pixelsPerFrame: Number) {
		// falling blocks
		this._counter = 0;

		this._grid = grid;
		this._ppf = pixelsPerFrame;

		this._hasBeenInitialized = true;

		this._fb = new Array(grid.getSizeInBlocks().width);
		for(var i = 0; i < this._fb.length; i++) 
			this._fb[i] = null;

		trace("Gravity initialized.");
	}

	public function populateFallingList() {
		var g = this._grid;
		
		var block;
		for(var x = 0; x < g.getWidthInBlocks(); x++) {
			block = g.getBlock(x, g.getHeightInBlocks() - 1); 
			if(Common.isInvalid(block)) block = g.getNextHighestBlock(new Location(x, 0));

			if(Common.isValid(block))	this._fb.push(block);
		}
	}

	public function addToFallingList(fallingBlock: GridBlock) {
		var gl = fallingBlock.getGridLocation();

		if(Common.isInvalid(this._fb[gl.x])) {
			this._fb[gl.x] = fallingBlock;
		} else {
			var fgl = this._fb[gl.x].getGridLocation();
			if(gl.y < fgl.y) 
				this._fb[gl.x] = fallingBlock;
		}
	}
		
	public function applyGravity(): Void {
		if(not this._hasBeenInitialized) return;
		for(var c = 0; c < this._ppf; c++)
			for(var i = 0; i < this._fb.length; i++) {
				if(not this._fb[i].dropBlock())
					this._fb[i] = this._fb[i].getBlockAbove();
			}	
	}
}
