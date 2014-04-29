package io.github.dector.ld29;

import flixel.FlxG;
import flixel.FlxState;

class BaseState extends FlxState {

	override public function update(): Void {
		super.update();

		if (FlxG.keys.justPressed.F) {
			toggleFullscreen();
		}
	}

	private function toggleFullscreen(): Void {
		FlxG.fullscreen = ! FlxG.fullscreen;
	}

}
