package io.github.dector.ld29;

class Utils {

	private function new() {}

	public static function time(): Int {
		#if flash
			return flash.Lib.getTimer();
        #else
			return Sys.time();
		#end
	}

	public static function exit(): Void {
		#if ! flash
		    Sys.exit(0);
		#end
	}
}
