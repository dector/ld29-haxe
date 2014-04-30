package io.github.dector.ld29;

import io.github.dector.ld29.Level.ShotResult;
import flixel.FlxObject;
import io.github.dector.ld29.Level.ShotResult;
import flixel.util.FlxRandom;

class Level0 extends Level {

	private var fishColors: Array<Int> = [ 0xff0000, 0x00ff00, 0x0000ff ];

    public function new() {
        super();
    }

	override public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		var result = new ShotResult();

		for (object in objects) {
			if (Std.is(object, Fish)) {
				var fish = cast(object, Fish);
				var fullInPointer = isObjectFullInPointer(cam, fish);

				if (fullInPointer) {
					result.setType(Level.ShotResultType.LEVEL_FINISHED);
				} else if (! result.hasMessage()) {
					result.setMessage("Fish isn't fully visible in camera");
				}
			}

			if (objects.isEmpty()) {
				result.setMessage("No any fish in camera viewfinder");
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

	override public function getGoalText(): String {
		return "Try to take picture of some fish";
	}

	override public function getFailText(): String {
		return "No-no. Make photo of whole fish";
	}

	/*@Override
	public Class<? extends Level> getNextLevel() {
	return Level1.class;
	}*/

}
