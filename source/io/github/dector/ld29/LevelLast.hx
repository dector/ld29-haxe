package io.github.dector.ld29;

import flixel.util.FlxRandom;
import io.github.dector.ld29.Level.ShotResult;
import flixel.FlxObject;
class LevelLast extends Level {

	public function new() {
		super();
	}

	override public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		var shotResult = new ShotResult();
		shotResult.type = Level.ShotResultType.LEVEL_FINISHED;
		return shotResult;
	}

	override public function newColor(): Int {
		return FlxRandom.intRanged(0x00, 0xff) << 16
			| FlxRandom.intRanged(0x00, 0xff) << 8
			| FlxRandom.intRanged(0x00, 0xff);
	}

	override public function getMaxFishCount(): Int {
		return 40;
	}

	override public function getMaxPlantsCount(): Int {
		return 20;
	}

	override public function getGoalText(): String {
		return "Relax";
	}

	override public function getFailText(): String {
		return "";
	}

	/*override public function getNextLevel(): Class<Level> {
		return null;
	}*/
}
