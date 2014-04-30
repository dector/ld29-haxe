package io.github.dector.ld29;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class SplashState extends BaseState {

	private var flag: FlxSprite;

	private var titleText: FlxText;
	private var instructionsText: FlxText;
	private var controlsText: FlxText;

	private var fadingTime: Int;

	override public function create(): Void {
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff353535;

		flag = new FlxSprite(550, 400);
		flag.loadGraphic("assets/flag.png");

		titleText = new FlxText(0, 100, FlxG.width, "Blue waves");
		titleText.setFormat(null, 80);
		titleText.alignment ="center";

		instructionsText = new FlxText(0, 300, FlxG.width, "Press ANY key to continue");
		instructionsText.setFormat(null, 20);
		instructionsText.alignment = "center";
		instructionsText.visible = false;

		controlsText = new FlxText(30, 500, FlxG.width / 2, "F - fullscreen\nR - relax mode");
		controlsText.setFormat(null, 20);
		controlsText.alignment = "left";
		controlsText.visible = false;

		add(titleText);
		add(instructionsText);
		add(controlsText);
		add(flag);

		fadingTime = 2147483647; //Int.MAX_VALUE;

		FlxG.camera.flash(0x88000000, 0.7, flashFinished);
	}

	override public function update(): Void {
		super.update();

		if (FlxG.keys.pressed.R) {
			//startLevel(new LevelLast());
		}

		if (FlxG.keys.pressed.ESCAPE) {
            Utils.exit();
		} else if (FlxG.keys.justPressed.ANY && ! FlxG.keys.pressed.F) {
			startLevel(new Level0());
		}
	}

	private function startLevel(level: Level): Void {
		Level.current = level;

		FlxG.camera.fade(0x88000000, 0.7, false, fadingFinished);
	}

	private function flashFinished(): Void {
		fadingTime = Std.int(Utils.time()) + 1000;

		instructionsText.visible = true;
		controlsText.visible = true;

		var options: TweenOptions = { type: FlxTween.PINGPONG, ease: null }
		FlxTween.tween(instructionsText.scale, { x: 1.2, y: 1.2 }, 0.7, options);
	}

	private function fadingFinished(): Void {
		nextState();
	}

	private function nextState(): Void {
		FlxG.switchState(new GameState());
	}
}
