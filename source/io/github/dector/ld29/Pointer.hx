package io.github.dector.ld29;

import flixel.FlxG;
import flixel.FlxSprite;

class Pointer extends FlxSprite {

	public function new() {
		super();

		loadGraphic("assets/camera.png", false, 100, 80);
	}

	override public function update(): Void {
		super.update();

		x = FlxG.mouse.screenX - width / 2;
		y = FlxG.mouse.screenY - height / 2;
	}

	public function makePhoto(shotResult: Level.ShotResult): Void {
		if (shotResult.type == Level.ShotResultType.WRONG) {
			FlxG.camera.flash(0xeeeeee, 0.5);
		} else {
			FlxG.camera.flash(0xffffff, 0.5);
		}
	}
}
