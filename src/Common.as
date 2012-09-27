class Common { 
	public static function isInvalid(ptr): Boolean {
		return ptr == undefined || ptr == null;
	}

	public static function isValid(ptr): Boolean {
		return not isInvalid(ptr);
	}
}