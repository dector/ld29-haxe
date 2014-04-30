package io.github.dector.ld29;

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
            #if ! flash
			Sys.exit(0);
            #else
            #end
		} else if (FlxG.keys.justPressed.ANY && ! FlxG.keys.pressed.F) {
			startLevel(new Level0());
		}
	}

	private function startLevel(level: Level): Void {
		Level.current = level;

		FlxG.camera.fade(0x88000000, 0.7, false, fadingFinished);
	}

	private function flashFinished(): Void {
        #if flash
		fadingTime = Std.int(flash.Lib.getTimer()) + 1000;
        #else
		fadingTime = Std.int(Sys.time()) + 1000;
        #end

		instructionsText.visible = true;
		controlsText.visible = true;
		/*Tween.to(instructionsText, TweenSprite.SCALE_XY, .7f)
				.target(1.2f, 1.2f)
				.ease(TweenEquations.easeNone)
				.repeatYoyo(Tween.INFINITY, 0)
				.build()
				.start(TweenPlugin.manager);*/
	}

	private function fadingFinished(): Void {
		nextState();
	}

	private function nextState(): Void {
		FlxG.switchState(new GameState());
	}
}
