package io.github.dector.ld29;

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

//	private long restoreInfoTimestamp;
//	private long fadingTimestamp;
//
//	private ActionStarter actionStarter;
//

	override public function create(): Void {

		FlxG.mouse.visible = false;

//	soundManager = new SoundManager();

		background = new FlxSprite();
		background.loadGraphic("assets/background.png");

		fishes = createFishes();
		plants = createPlants();
		pointer = new Pointer();

		hud = new FlxGroup();

//	infoText = new FlxText(10, 10, FlxG.width - 20);
//	infoText.setFormat(null, 25);
//	infoText.setText(Level.current.getGoalText());
//	hud.add(infoText);
//
	musicIndicator = new FlxSprite(FlxG.width - 16 - 32, FlxG.height - 16 - 32);
	musicIndicator.loadGraphic("assets/music.png", true, 16, 16);
	musicIndicator.animation.add("on", [ 0 ], 0);
	musicIndicator.animation.add("off", [ 1 ], 0);
	musicIndicator.scale.set(2, 2);
	musicIndicator.width = 32;
	musicIndicator.height = 32;
	musicIndicator.origin.set(0, 0);
	hud.add(musicIndicator);

//	fishEmmiters = getFishesEmmiters();


	add(background);
	add(fishes);
//	add(fishEmmiters);
	add(plants);
	add(hud);
	add(pointer);

	MusicManager.instance.play();
	updateIndicators();
//
//	if (Level.current.getClass() == LevelLast.class) {
//	levelDone = true;
//	pointer.visible = false;
//	}
//	}

	}

	private function updateIndicators() {
		musicIndicator.animation.play(MusicManager.instance.isMuted() ? "off" : "on");
	}

//	private FlxGroup getFishesEmmiters() {
//	FlxGroup emmiters = new FlxGroup();
//
//	for (FlxBasic obj : fishes.members) {
//	Fish fish = (Fish) obj;
//	emmiters.add(fish.getEmmiter());
//	}
//
//	return emmiters;
//	}
//

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

		//	if (actionStarter == null) {
		//	actionStarter = new ActionStarter();
		//	}
		//
		//	int stepX = FlxG.width / Level.current.getMaxPlantsCount();
		//	int diffX = stepX / 2;
		//
		//	for (int i = 0; i < Level.current.getMaxPlantsCount(); i++) {
		//	final FlxSprite plant = new FlxSprite();
		//	plant.loadGraphic("assets/plant.png", true, false, 12, 28);
		//	plant.setColor(0x00ff00);
		//	plant.addAnimation("stand", new int[] { 1 }, 1, true);
		//	plant.addAnimation("wave", new int[] { 0, 1, 2, 1 }, 1, true);
		//		//            plant.addAnimation("wave_long", new int[] { 0, 0, 1, 1, 2, 2, 1, 1 }, 1, true);
		//		//            plant.addAnimation("wave_left", new int[] { 0, 0, 0, 1, 1 }, 1, true);
		//		//            plant.addAnimation("wave_right", new int[] { 1, 2, 2, 2, 2 }, 1, true);
		//	actionStarter.startDelayed(new Runnable() {
		//	@Override
		//	public void run() {
		//	plant.play("wave", true, MathUtils.random(0, 2));
		//	}
		//	}, MathUtils.random(0, 2000));
		//	plant.origin.make(0, 0);
		//	int scale = MathUtils.random(2, 10);
		//	plant.width = 12 * scale;
		//	plant.height = 28 * scale;
		//	plant.scale.make(scale, scale);
		//		//            plant.x = MathUtils.random(0, FlxG.width);
		//	float x = i * stepX + MathUtils.random(-1f, 1f) * diffX;
		//	if (x < 0) x = plant.width / 2;
		//	if (x > FlxG.width) x = FlxG.width - plant.width / 2;
		//	plant.x = x;
		//	plant.y = FlxG.height - plant.height;
		//	plants.add(plant);
		//	}
		//

		return plants;
	}


	override public function update(): Void {
		super.update();

		if (FlxG.keys.pressed.ESCAPE) {
			MusicManager.instance.pause();

			#if debug
				Sys.exit(0);
			#else
				FlxG.switchState(new SplashState());
			#end
		}

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

//	if (! levelDone && FlxG.mouse.justPressed()) {
//	List<FlxObject> objects = getObjectsOnPhoto();
//	Level.ShotResult shotResult = Level.current.makePhoto(pointer, objects);
//
//	pointer.makePhoto(shotResult);
//
//	switch (shotResult.type) {
//	case WRONG:
//	soundManager.playWrong();
//	if (shotResult.hasMessage()) {
//	infoText.setText(shotResult.getMessage());
//	} else {
//	infoText.setText(Level.current.getFailText());
//	}
//	restoreInfoTimestamp = System.currentTimeMillis() + 2000;
//	break;
//	case CORRECT:
//	soundManager.playShot();
//	if (shotResult.hasMessage()) {
//	infoText.setText(shotResult.getMessage());
//	} else {
//	infoText.setText(Level.current.getCorrectText());
//	}
//	restoreInfoTimestamp = System.currentTimeMillis() + 1000;
//	break;
//	case LEVEL_FINISHED:
//	soundManager.playShot();
//	if (shotResult.hasMessage()) {
//	infoText.setText(shotResult.getMessage());
//	} else {
//	infoText.setText(Level.current.getCorrectText());
//	}
//	restoreInfoTimestamp = Long.MAX_VALUE;
//	fadingTimestamp = System.currentTimeMillis() + 1000;
//	levelDone = true;
//	break;
//	}
//	}
//
//	long currentTimestamp = System.currentTimeMillis();
//	if (fadingTimestamp != 0 && fadingTimestamp <= currentTimestamp) {
//	nextLevel();
//	fadingTimestamp = 0;
//	} else if (restoreInfoTimestamp != 0 && restoreInfoTimestamp <= currentTimestamp) {
//	infoText.setText(Level.current.getGoalText());
//	restoreInfoTimestamp = 0;
//	}
//
//	updateFishes();
//
//	actionStarter.update();
//	}

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

//		// FIXME Dirty hack. Because reused fish sometimes is drawing incorrect for updated scale and size values
//	private List<Fish> removedFishes = new ArrayList<Fish>();
//	private List<Fish> newFishes = new ArrayList<Fish>();
//
//	private void updateFishes() {
//	for (FlxBasic obj : fishes.members) {
//	Fish fish = (Fish) obj;
//
//	if (! fish.onScreen()) {
//	fish.kill();
//	removedFishes.add(fish);
//
//	int facing = MathUtils.randomBoolean()
//	? Fish.LEFT
//	: Fish.RIGHT;
//	newFishes.add(new Fish(facing));
//	}
//	}
//
//	if (! removedFishes.isEmpty()) {
//	for (Fish fish : removedFishes) {
//	fishes.remove(fish);
//
//	FlxEmitter emitter = fish.getEmmiter();
//	fishEmmiters.remove(emitter);
//	}
//	removedFishes.clear();
//	}
//
//	if (! newFishes.isEmpty()) {
//	for (Fish fish : newFishes) {
//	fishes.add(fish);
//	fishEmmiters.add(fish.getEmmiter());
//	}
//	newFishes.clear();
//	}
//	}
//
//	public List<FlxObject> getObjectsOnPhoto() {
//	List<FlxObject> objects = new ArrayList<FlxObject>();
//
//	for (FlxBasic obj : fishes.members) {
//	Fish fish = (Fish) obj;
//
//	if (pointer.overlaps(fish)) {
//	objects.add(fish);
//	}
//	}
//
//	return objects;
//	}*/
}
