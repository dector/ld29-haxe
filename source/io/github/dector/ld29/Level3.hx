package io.github.dector.ld29;

import io.github.dector.ld29.Level.ShotResult;
import flixel.FlxObject;
import io.github.dector.ld29.Level.ShotResult;
import flixel.util.FlxRandom;

class Level3 extends Level {

	private inline static var PHOTOS_GOAL = 3;

	private var photosCount: Int;

	private var checkResult: Bool;
	private var bigFishes = new List<Fish>();
	private var smallFishes = new List<Fish>();

    public function new() {
        super();
    }

	override public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		var result = new ShotResult();

		var aimedOnBigFish = false;

		for (object in objects) {
			if (Std.is(object, Fish)) {
				var fish = cast(object, Fish);

				checkResult =  true;

				var fullInPointer = isObjectFullInPointer(cam, fish);
				var bigEnough = fish.getSize2() >= 3;
				aimedOnBigFish = aimedOnBigFish || bigEnough;

				if (fullInPointer && ! fish.hasPhoto) {
					if (bigEnough) {
						bigFishes.add(fish);
					} else {
						smallFishes.add(fish);
					}
				} else if (! result.hasMessage()) {
					if (fish.hasPhoto) {
						result.setMessage("We already have photo of this fish");
					} else {
						result.setMessage("Fish isn't fully visible in camera");
					}
				}
			}

			if (checkResult) {
				if (bigFishes.isEmpty()) {
					result.setMessage("Can't see big fish here, huh");
				} else if (smallFishes.isEmpty()) {
					result.setMessage("Try to catch smaller one with bigger fish");
				} else {
					for (f in bigFishes) {
						f.hasPhoto = true;
					}
					for (f in smallFishes) {
						f.hasPhoto = true;
					}

					bigFishes.clear();
					smallFishes.clear();

					photosCount++;
					if (photosCount == PHOTOS_GOAL) {
						result.setType(Level.ShotResultType.LEVEL_FINISHED);
					} else {
						result.setType(Level.ShotResultType.CORRECT);
					}
				}

				checkResult = false;
			}

			if (objects.isEmpty()) {
				result.setMessage("No any fish in camera viewfinder");
			} else if (objects.length == 1) {
				result.setMessage("We need two fishes on one photo");
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
		return FlxRandom.intRanged(0x00, 0xff) << 16
			| FlxRandom.intRanged(0x00, 0xff) << 8
			| FlxRandom.intRanged(0x00, 0xff);
	}

	override public function getMaxFishCount(): Int {
		return 30;
	}

	override public function getMaxPlantsCount(): Int {
		return 15;
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
			return "Now make two photos of big fish with smaller one";
		} else {
			return "Only " + (PHOTOS_GOAL - photosCount) + " photos left";
		}
	}

	override public function getFailText(): String {
		return "Oops. Aim better";
	}

	override public function hasNextLevel(): Bool {
		return true;
	}

	override public function getNextLevel(): Level {
		return new LevelLast();
	}

}
