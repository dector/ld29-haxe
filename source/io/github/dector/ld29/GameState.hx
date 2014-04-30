package io.github.dector.ld29;

import io.github.dector.ld29.Level.ShotResult;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import haxe.Timer;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class GameState extends BaseState {

	//private SoundManager soundManager;

	private var musicIndicator: FlxSprite;

	private var background: FlxSprite;

	private var plants: FlxGroup;

	private var fishes: FlxGroup;
	private var fishEmmiters: FlxGroup;

	private var hud: FlxGroup;
	private var infoText: FlxText;

	private var pointer: Pointer;

	private var levelDone: Bool;

//	private ActionStarter actionStarter;

	override public function create(): Void {

		FlxG.mouse.visible = false;

//	soundManager = new SoundManager();

		background = new FlxSprite();
		background.loadGraphic("assets/background.png");

		fishes = createFishes();
		plants = createPlants();
		pointer = new Pointer();

		hud = new FlxGroup();

        infoText = new FlxText(10, 10, FlxG.width - 20);
        infoText.setFormat(null, 25);
        infoText.text = Level.current.getGoalText();
        hud.add(infoText);

        musicIndicator = new FlxSprite(FlxG.width - 16 - 32, FlxG.height - 16 - 32);
        musicIndicator.loadGraphic("assets/music.png", true, 16, 16);
        musicIndicator.animation.add("on", [ 0 ], 0);
        musicIndicator.animation.add("off", [ 1 ], 0);
        musicIndicator.scale.set(2, 2);
        musicIndicator.width = 32;
        musicIndicator.height = 32;
        musicIndicator.origin.set(0, 0);
        hud.add(musicIndicator);

    	fishEmmiters = getFishesEmmiters();

        add(background);
        add(fishes);
    	add(fishEmmiters);
        add(plants);
        add(hud);
        add(pointer);

        MusicManager.instance.play();
        updateIndicators();

//	if (Level.current.getClass() == LevelLast.class) {
//	levelDone = true;
//	pointer.visible = false;
//	}
//	}

	}

	private function updateIndicators() {
		musicIndicator.animation.play(MusicManager.instance.isMuted() ? "off" : "on");
	}

	private function getFishesEmmiters(): FlxGroup {
        var emmiters = new FlxGroup();

        for (obj in fishes.members) {
            var fish = cast(obj, Fish);
            emmiters.add(fish.getEmmiter());
        }

        return emmiters;
	}


	private function createFishes(): FlxGroup {
		var fishes = new FlxGroup();

		var max = Level.current.getMaxFishCount();
		for (i in 0...max) {
			fishes.add(new Fish());
		}

		return fishes;
	}

	private function createPlants(): FlxGroup {
		var plants = new FlxGroup();

        var stepX = FlxG.width / Level.current.getMaxPlantsCount();
        var diffX = stepX / 2;

        for (i in 0...Level.current.getMaxPlantsCount()) {
            var plant = new FlxSprite();
            plant.loadGraphic("assets/plant.png", true, 12, 28);
            plant.color = 0x00ff00;
            plant.animation.add("stand", [ 1 ], 0, true);
            plant.animation.add("wave", [ 0, 1, 2, 1], 1, true);

            var updatePlant = function() {
                plant.animation.play("wave", true, FlxRandom.intRanged(0, 2));
            };

            Timer.delay(updatePlant, FlxRandom.intRanged(0, 2000));

            var scale = FlxRandom.intRanged(2, 10);
            plant.width = 12 * scale;
            plant.height = 28 * scale;
            plant.origin.set(0, 0);
            plant.scale.set(scale, scale);

            var x = i * stepX + FlxRandom.floatRanged(-1, 1) * diffX;
            if (x < 0) x = plant.width / 2;
            if (x > FlxG.width) x = FlxG.width - plant.width / 2;

            plant.x = x;
            plant.y = FlxG.height - plant.height;
            plants.add(plant);
        }

		return plants;
	}


	override public function update(): Void {
		super.update();

		if (FlxG.keys.pressed.ESCAPE) {
			MusicManager.instance.pause();

			#if debug
			    Utils.exit();
			#else
				FlxG.switchState(new SplashState());
			#end
		}

		//#if debug
		if (FlxG.keys.pressed.D) {
			FlxG.debugger.drawDebug = true;
		}
		//#end

//	if (FlxG.debug) {
//	if (FlxG.keys.R) {
//	try {
//	Level.current = Level.current.getClass().newInstance();
//	} catch (Exception e) {
//	}
//	FlxG.resetState();
//	}
//	if (FlxG.keys.N) {
//	nextLevel();
//	}
//
//	if (FlxG.keys.P) {
//	((Fish) fishes.getRandom()).bubble();
//	}
//	}
//
		if (FlxG.keys.justPressed.M) {
			MusicManager.instance.switchMute();
			updateIndicators();
		}
		if (FlxG.keys.justPressed.PLUS) {
			//MusicManager.instance.volumeUp();
			updateIndicators();
		}
		if (FlxG.keys.justPressed.MINUS) {
			//MusicManager.instance.volumeDown();
			updateIndicators();
		}

		if (! levelDone && FlxG.mouse.justPressed) {
			var objects = getObjectsOnPhoto();
			var shotResult = Level.current.makePhoto(pointer, objects);

			pointer.makePhoto(shotResult);

			switch (shotResult.type) {
				case Level.ShotResultType.WRONG:
					if (shotResult.hasMessage()) {
						infoText.text = shotResult.getMessage();
					} else {
						infoText.text = Level.current.getFailText();
					}

					var restoreInfo = function() {
						infoText.text = Level.current.getGoalText();
					}
					Timer.delay(restoreInfo, 2000);
				case Level.ShotResultType.CORRECT:
					if (shotResult.hasMessage()) {
						infoText.text = shotResult.getMessage();
					} else {
						infoText.text = Level.current.getCorrectText();
					}

					var restoreInfo = function() {
						infoText.text = Level.current.getGoalText();
					}
					Timer.delay(restoreInfo, 1000);
				case Level.ShotResultType.LEVEL_FINISHED:
					if (shotResult.hasMessage()) {
						infoText.text = shotResult.getMessage();
					} else {
						infoText.text = Level.current.getCorrectText();
					}

					var restoreInfo = function() {
						infoText.text = Level.current.getGoalText();
					}
					Timer.delay(restoreInfo, 1000);
					levelDone = true;
			}
		}

		updateFishes();
	}

	private function nextLevel(): Void {
		var nextLevel = Level.current.getNextLevel;

		if (nextLevel != null) {
			FlxG.camera.fade(0x88000000, 1.5, false, gotoNextLevel);
		}
	}

	private function gotoNextLevel(): Void {
		Level.current = Type.createInstance(Level.current.getNextLevel(), []);
		FlxG.resetState();
	}

	// FIXME Dirty hack. Because reused fish sometimes is drawing incorrect for updated scale and size values
	private var removedFishes = new List<Fish>();
	private var newFishes = new List<Fish>();

	private function updateFishes(): Void {
		for (obj in fishes) {
			var fish = cast(obj, Fish);

			if (! fish.isOnScreen()) {
				fish.kill();
				removedFishes.add(fish);

				var facing = FlxRandom.intRanged(0, 1) == 1
					? FlxObject.LEFT : FlxObject.RIGHT;

				newFishes.add(new Fish(facing));
			}
		}

		if (! removedFishes.isEmpty()) {
			for (fish in removedFishes) {
				fishes.remove(fish);

				var emitter = fish.getEmmiter();
				fishEmmiters.remove(emitter);
			}

			removedFishes.clear();
		}

		if (! newFishes.isEmpty()) {
			for (fish in newFishes) {
				fishes.add(fish);
				fishEmmiters.add(fish.getEmmiter());
			}

			newFishes.clear();
		}
	}

	private function getObjectsOnPhoto(): List<FlxObject> {
		var objects = new List<FlxObject>();

		for (obj in fishes.members) {
			var fish = cast(obj, Fish);

			if (pointer.overlaps(fish)) {
				objects.add(fish);
			}
		}

		return objects;
	}

	override public function onFocus(): Void {
		MusicManager.instance.pauseSoft();
	}

	override public function onFocusLost(): Void {
		MusicManager.instance.playSoft();
	}
}
