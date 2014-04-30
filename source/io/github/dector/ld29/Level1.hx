package io.github.dector.ld29;

import io.github.dector.ld29.Level.ShotResult;
import flixel.FlxObject;
import io.github.dector.ld29.Level.ShotResult;
import flixel.util.FlxRandom;

class Level1 extends Level {

	private var fishColors: Array<Int> = [ 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff ];

    public function new() {
        super();
    }

	override public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		var result = new ShotResult();

		var aimedOnRedFish = false;

		for (object in objects) {
			if (Std.is(object, Fish)) {
				var fish = cast(object, Fish);
				var fullInPointer = isObjectFullInPointer(cam, fish);
				var redFish = (fish.color & 0xffffff) == 0xff0000;
				aimedOnRedFish = aimedOnRedFish || redFish;

				if (fullInPointer) {
					result.setType(Level.ShotResultType.LEVEL_FINISHED);
				} else if (! result.hasMessage()) {
					result.setMessage("Fish isn't fully visible in camera");
				}
			}

			if (objects.isEmpty()) {
				result.setMessage("No any fish in camera viewfinder");
			} else if (! aimedOnRedFish) {
				result.setMessage("We are looking for red fish");
			}
			if (result.getType() == Level.ShotResultType.LEVEL_FINISHED) {
				result.setMessage(null);
			}

			if (result.getType() == Level.ShotResultType.LEVEL_FINISHED)
				break;
		}

		return result;
	}

	override public function newColor(): Int {
		return fishColors[FlxRandom.intRanged(0, fishColors.length - 1)];
	}

	override public function getMaxFishCount(): Int {
		return 20;
	}

	override public function getGoalText(): String {
		return "Now try to get photo of red fish";
	}

	override public function getFailText(): String {
		return "We need red fish";
	}

	override public function hasNextLevel(): Bool {
		return true;
	}

	override public function getNextLevel(): Level {
		return new Level2();
	}

}
