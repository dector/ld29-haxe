package io.github.dector.ld29;

import flixel.util.FlxRandom;
import flixel.FlxObject;

class Level {

	public static var current: Level;

	/*private static var levelset: Array<Dynamic>;
	private static var currentIndex: Int;

	public static function getNext(): Class<Level> {
		if (currentIndex < levelset.length) {
			return levelset[currentIndex + 1];
		} else {
			return null;
		}
	}*/

	public function __init__(): Void {
		current = new Level0();
		/*currentIndex = 0;
		levelset = [ Type.typeof(Level0), Type.typeof(Level1), Type.typeof(Level2),
			Type.typeof(Level3), Type.typeof(LevelLast) ];*/
	}

    public function new() {

    }

	private static var completeText: Array<String> = [
		"Well done!",
		"Awesome!",
		"It was easy, huh?",
		"Super!",
		"You are lucky"
	];

	public function isObjectFullInPointer(cam: Pointer, object: FlxObject): Bool {
		return cam.x <= object.x && object.x + object.width <= cam.x + cam.width
			&& cam.y <= object.y && object.y + object.height <= cam.y + cam.height;
	}

	public function makePhoto(cam: Pointer, objects: List<FlxObject>): ShotResult {
		return null;
	}

	public function newColor(): Int {
		return 0;
	}

	public function getSize(): Int {
		return FlxRandom.intRanged(1, 3);
//		return Fish.Size.values()[MathUtils.random(Fish.Size.values().length - 1)];
	}

	public function getMaxFishCount(): Int {
		return 10;
	}

	public function getMaxPlantsCount(): Int {
		return 10;
	}

	public function getGoalText(): String {
		return null;
	}

	public function getCorrectText(): String {
		return completeText[FlxRandom.intRanged(0, completeText.length - 1)];
	}

	public function getFailText(): String {
		return null;
	}

	public function hasNextLevel(): Bool {
		return false;
	}

	public function getNextLevel(): Level {
		return null;
	}

	/*public function getNextLevel<T : Level>(): Class<T> {
		return null;
	}*/

}

class ShotResult {

	public var type: ShotResultType;
	public var message: String;

	public function new() {
		type = ShotResultType.WRONG;
	}

	public function getType(): ShotResultType {
		return type;
	}

	public function setType(type: ShotResultType): Void {
		this.type = type;
	}

	public function getMessage(): String {
		return message;
	}

	public function setMessage(message: String): Void {
		this.message = message;
	}

	public function hasMessage(): Bool {
		return message != null;
	}
}

enum ShotResultType {
	WRONG;
	CORRECT;
	LEVEL_FINISHED;
}
