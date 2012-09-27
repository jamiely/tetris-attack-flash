class BlockView extends MovieClip {
	var _block;
	
	public function playMatch(br: BlockRemover) {
		this.playDisappear(br);
	}
	public function playDisappear(br: BlockRemover) {
		br.removeBlock(this.getBlock());
	}
	public function getBlock(): Block {
		return this._block;
	}
	public function setBlock(block: Block): Void {
		this._block = block;
	}
}