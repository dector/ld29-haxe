package io.github.dector.ld29;

import io.github.dector.ld29.Level.ShotResult;
import flixel.FlxObject;
import io.github.dector.ld29.Level.ShotResult;
import flixel.util.FlxRandom;

class Level2 extends Level {

	private inline static var BIG_FISH_COUNT_GOAL = 3;

	private var fishColors: Array<Int> = [ 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff ];

	private var photosCount: Int;

    public function new() {
        super();
    }

	override public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		var result = new ShotResult();

		var aimedOnBigFish = false;

		for (object in objects) {
			if (Std.is(object, Fish)) {
				var fish = cast(object, Fish);
				var fullInPointer = isObjectFullInPointer(cam, fish);
				var bigEnough = fish.getSize2() >= 3;
				aimedOnBigFish = aimedOnBigFish || bigEnough;

				if (fullInPointer && bigEnough && ! fish.hasPhoto) {
					fish.hasPhoto = true;

					photosCount++;

					if (photosCount == BIG_FISH_COUNT_GOAL) {
						result.setType(Level.ShotResultType.LEVEL_FINISHED);
					} else {
						result.setType(Level.ShotResultType.CORRECT);
					}
				} else if (! result.hasMessage()) {
					if (fish.hasPhoto) {
						result.setMessage("We already have photo of this fish");
					} else {
						result.setMessage("Fish isn't fully visible in camera");
					}
				}
			}

			if (objects.isEmpty()) {
				result.setMessage("No any fish in camera viewfinder");
			} else if (! aimedOnBigFish) {
				result.setMessage("Fish isn't big enough");
			}
			if (result.getType() == Level.ShotResultType.CORRECT) {
				result.setMessage(null);
			} else if (result.getType() == Level.ShotResultType.LEVEL_FINISHED) {
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

	override public function getSize(): Int {
		var size = super.getSize();
		if (size >= 2 && FlxRandom.float() > 0.1) {
			size = super.getSize();
		}
		return size;
	}

	override public function getGoalText(): String {
		if (photosCount == 0) {
			return "We need 3 photos of big fish";
		} else {
			return "Only " + (BIG_FISH_COUNT_GOAL - photosCount) + " photos with big fish left";
		}
	}

	override public function getFailText(): String {
		return "Oops. Aim better";
	}

	override public function hasNextLevel(): Bool {
		return true;
	}

	override public function getNextLevel(): Level {
		return new Level3();
	}

}
