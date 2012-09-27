class BlockRemover extends MovieClip {
	/**
	 * An array of blocks to make disappear.
	 */
	public function initialize(blocks: Array): Void {
		for(var i=0; i < blocks.length; i++) {
			// play matched animation
			block.getView().gotoAndStop("matched");
			
			// play disappear animation
			block.getView().gotoAndStop("disappear");
			// remove
		}
	}

	public function matched(): Void {
		
	}

	public function disappear(): Void {

	}
}