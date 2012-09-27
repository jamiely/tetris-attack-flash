class BlockFactory extends MyObject {
	private var _blockIdentifiers: Array = new Array(
		"BlockBlue",
		"BlockGreen",
		"BlockRed",
		//"BlockTeal",
		"BlockViolet",
		"BlockYellow"
		);

	private var _canvas: MovieClip = null;
	private var _counter: Number;

	public function BlockFactory(canvas: MovieClip) {
		this._canvas = canvas;
		this._counter = 0;
	}

	public function getRandomBlock(): GridBlock {
		var blockType: Number = Math.floor(Math.random() * this._blockIdentifiers.length);
		//trace("BlockType: " + blockType);
		var bi: String = this._blockIdentifiers[blockType];
		//trace("BlockIdentifier: " + bi);
		incrementCounter();
		var block: GridBlock = new GridBlock(this._canvas, bi, blockType + 1);		
		//trace("Block: " + block);
		return block;
	}
	
	public function getBlock(mcIdentifier: String): GridBlock { 
		var blockType = this.getBlockType(mcIdentifier);
		var bi: String = this._blockIdentifiers[blockType];
		incrementCounter();
		return new GridBlock(this._canvas, bi, blockType + 1);
	}

	public function getBlockType(mcIndentifier: String): Number {
		for(var i = 0; i < this._blockIdentifiers.length; i++) 
			if(this._blockIdentifiers[i] == mcIndentifier) 
				return i;
		return 0;
	}

	private function incrementCounter(): Number {
		this._counter++;
		return this._counter;
	}
}		
		