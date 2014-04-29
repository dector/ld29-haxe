package io.github.dector.ld29;

import flixel.util.FlxRandom;
import flixel.FlxObject;

class Level {

	public static var current: Level;

	public function __init__(): Void {
		current = new Level0();
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

	public function getNextLevel(): Class<Level> {
		return null;
	}

}

class ShotResult {

	public var type: ShotResultType;
	public var message: String;

	function new() {
		type = ShotResultType.WRONG;
	}

	public function getType(): ShotResultType {
		return type;
	}

	function setType(type: ShotResultType): Void {
		this.type = type;
	}

	public function getMessage(): String {
		return message;
	}

	function setMessage(message: String): Void {
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
