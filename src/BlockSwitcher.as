class BlockSwitcher extends MovieClip {
	private var _counter: Number = 0;
	public var _lower: GridBlock;
	public var _higher: GridBlock;
	public var _lefter: GridBlock;
	public var _righter: GridBlock;
	private var _blockWidth: Number;

	private var _onSwitchExecutables: Array;

	public var _lowerOriginalLocation: Location,
		_higherOriginalLocation: Location,
		_lowerOriginalGridLocation: Location,
		_higherOriginalGridLocation: Location;

	/**
	 * The number of frames to use to perform 
	 * the swap.
	 */
	public var _transitionFrames: Number; 
	public var _hasBeenInitialized: Boolean = false;
	private var _velocityX: Number;
	private var _velocityY: Number;

	public function initialize(b1: GridBlock, b2: GridBlock, tf: Number) {
		if(b1 == b2) this.removeMovieClip();

		var distanceX: Number, distanceY: Number;

		b1.setIsMoving(true);
		this._transitionFrames = tf;

		this._onSwitchExecutables = new Array();
		
		this._counter = 0;
		if(Common.isInvalid(b2)) {
			this._lower = this._higher =  null;
			this._lefter = b1;
			this._righter = null;
			distanceX =	b1.getWidth();
			
			this._velocityX = distanceX / tf;
			this._velocityY = 0;

			this._blockWidth = b1.getWidth();
			this._lowerOriginalLocation = b1.getLocation();

			this._hasBeenInitialized = true;

			this.onEnterFrame = oneBlock;

			//trace("ONE BLOCK");
			return;
		}

		b2.setIsMoving(true);

		// lower has a larger y
		if(b1.getLocation().y > b2.getLocation().y) {
			this._lower =  b1; 
			this._higher = b2;
		} else {
			this._lower = b2;
			this._higher = b1;
		}

		this._lowerOriginalLocation = this._lower.getLocation();
		this._higherOriginalLocation = this._higher.getLocation();

		this._lowerOriginalGridLocation = this._lower.getGridLocation();
		this._higherOriginalGridLocation = this._higher.getGridLocation();

		if(b1.getLocation().x > b2.getLocation().x) {
			this._lefter = b2;
			this._righter = b1;
		} else {
			this._lefter = b1;
			this._righter = b2;
		}

		distanceX = Math.abs(b1.getLocation().x - b2.getLocation().x);
	  distanceY = Math.abs(b1.getLocation().y - b2.getLocation().y);
		
		this._velocityX = distanceX / tf;
		this._velocityY = distanceY / tf;

		this.onEnterFrame = twoBlocks;

		this._hasBeenInitialized = true;

		//trace("TWO BLOCKS");
		//trace("Block switcher initialized.");	
	}
		
	public function twoBlocks(): Void {
		if(not this._hasBeenInitialized) return;

		this._counter++;
		if(this._counter > this._transitionFrames) {
		
			this._lower.setLocation(this._higherOriginalLocation);
			this._higher.setLocation(this._lowerOriginalLocation);

			this._higher.setGridLocation(this._lowerOriginalGridLocation);
			this._lower.setGridLocation(this._higherOriginalGridLocation);

			this._lower.setIsMoving(false); // stop movement
			this._higher.setIsMoving(false); // stop movement
		
			this.onSwitched();

			trace("Removing block switcher!!");
			this.removeMovieClip(); // remove the movie clip
		} else {
			this._lower.setIsMoving(true); // beegin movement
			this._higher.setIsMoving(true); // begin movement
			this._lower.setLocation(new Location(
				this._lower.getLocation().x, 
				this._lower.getLocation().y - this._velocityY));
			this._higher.setLocation(new Location(
				this._higher.getLocation().x, 
				this._higher.getLocation().y + this._velocityY));

			this._lefter.setLocation(new Location(
				this._lefter.getLocation().x + this._velocityX, 
				this._lefter.getLocation().y));
			this._righter.setLocation(new Location(
				this._righter.getLocation().x - this._velocityX, 
				this._righter.getLocation().y));
		}
	}

	public function oneBlock() {
		this._counter++;
		if(this._counter > this._transitionFrames) {
			
			this._lefter.setLocation( 
				new Location(this._lowerOriginalLocation.x + this._blockWidth, this._lowerOriginalLocation.y));

			var gl = this._lefter.getGridLocation();
			var above = this._lefter.getBlockAbove();
			this._lefter.setGridLocation(new Location(gl.x + 1, gl.y));
			
			this._lefter.setIsMoving(false);
		
			var grid = this._lefter.getGrid();
			var grav = grid.getGravity();

			grav.addToFallingList(above);
			grav.addToFallingList(this._lefter);

			this.onSwitched();

			this.removeMovieClip(); // remove the movie clip
		} else {
			this._lefter.setLocation(new Location(
				this._lefter.getLocation().x + this._velocityX, 
				this._lefter.getLocation().y));
		}
	}

	public function onSwitched() {
		for(var i = 0; i < this._onSwitchExecutables.length; i++) {
			trace(this._onSwitchExecutables[i]);
			this._onSwitchExecutables[i].execute();
		}
	}

	public function addOnSwitchHandler(obj: Executable): Void {
		this._onSwitchExecutables.push(obj);
	}
}
