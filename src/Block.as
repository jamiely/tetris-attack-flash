class Block extends Control { 
	/**
	 * The block type.
	 */
	private var _blockType: Number = -1;

	public function Block(parent: MovieClip, mcLinkageName: String, blockType: Number) {
		//trace("Creating Block");

		this.setBlockType(blockType); // block type is used to match blocks
		
		this.setParent(parent);
		//trace("Parent: " + this._parent);
		var depth:Number = this._parent.getNextHighestDepth();

		this.setName("block" + String(depth));
		// attach the movie clip representing the block to its _parent
		this.setView(this._parent.attachMovie(mcLinkageName, this.getName(), depth));
		//trace("View: " + this._view + " depth: " + depth);

		this.setLocation(new Location(0, 0));
		this.setSize(new Size(this.getView()._width, this.getView()._height));		

		//trace("Created Block");
	}

	public function getBlockType(): Number {
		return this._blockType;
	}

	public function setBlockType(blockType: Number): Void {
		this._blockType = blockType;
	}
	
	public function toString(): String {
		var returnString:String = "Block";
		return returnString;
	}
}