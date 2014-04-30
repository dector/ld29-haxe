package io.github.dector.ld29;

import flixel.FlxObject;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.FlxG;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxPoint;
import flixel.FlxSprite;

class Fish extends FlxSprite {

	private static inline var FISH_W = 28;
	private static inline var FISH_H = 12;

	private var size: Int;
	private var emitterOffset: FlxPoint;

	public var hasPhoto: Bool;

	private var lastBubbleTime: Int;
	private var emitter: FlxTypedEmitter<Bubble>;

	public function new(facing: Int = FlxObject.NONE) {
		super();

		emitterOffset = new FlxPoint();

		emitter = new FlxTypedEmitter();
		emitter.maxSize = 5;

		for (i in 0...emitter.maxSize) {
			emitter.add(new Bubble());
		}

		loadGraphic("assets/fish_t.png", false, 28, 12);
        setFacingFlip(FlxObject.LEFT, true, false);

		this.facing = facing;
		init();
	}

	private function init(): Void {
		hasPhoto = false;

		/*int color = 0xff << 24
		| MathUtils.random(0x00, 0xff) << 16
		| MathUtils.random(0x00, 0xff) << 8
		| MathUtils.random(0x00, 0xff);*/
		color = Level.current.newColor();

		y = FlxRandom.intRanged(0, FlxG.height);

		switch(facing) {
			case FlxObject.NONE:
				x = FlxRandom.intRanged(0, FlxG.width);
				facing = FlxRandom.intRanged(0, 1) == 1 ? FlxObject.RIGHT : FlxObject.LEFT;
			case FlxObject.LEFT:
				x = FlxG.width - 1;
			case FlxObject.RIGHT:
				x = 1 - width;
			default:
				return;
		}

		if (facing == FlxObject.LEFT) {
			velocity.x = -FlxRandom.intRanged(10, 100);
		} else {
			velocity.x = FlxRandom.intRanged(10, 100);
		}

		var fishSize = Level.current.getSize();
		setSize2(fishSize);

		// dirty = true;

        #if flash
        lastBubbleTime = flash.Lib.getTimer();
        #else
		lastBubbleTime = Std.int(Sys.time()) + FlxRandom.intRanged(1000, 4000);
        #end
	}

	public function getSize2(): Int {
		return size;
	}

	public function setSize2(size: Int): Void {
		width = FISH_W * size;
		height = FISH_H * size;

		scale.x = size;
		scale.y = size;

		// FIXme bug fish is lagging
        origin.set(0, 0);
		offset.set(0, 0);

		emitterOffset.x = facing == FlxObject.LEFT ? size * 5 : width - size * 5;
		emitterOffset.y = height - size * 4;

		this.size = size;
	}

	override public function update(): Void {
		super.update();

		emitter.x = x + emitterOffset.x;
		emitter.y = y + emitterOffset.y;

        var time;
        #if flash
        time = flash.Lib.getTimer();
        #else
        time = Sys.time();
        #end
		var currentTime = Std.int(time);
		if (lastBubbleTime <= currentTime) {
			bubble();
			lastBubbleTime = currentTime + FlxRandom.intRanged(2000, 5000);
		}
	}

	private function bubble(): Void {
		emitter.setXSpeed(-10, 10);
		emitter.setYSpeed(-20, -70);
		emitter.setRotation(10, 45);
		emitter.start(false, 5, 0.1, FlxRandom.intRanged(1, emitter.maxSize));
	}

	public function getEmmiter(): FlxTypedEmitter<Bubble> {
		return emitter;
	}

	// FIXME fix this sheet
	/*public function constructEnum(sizeEnum: SizeEnum): Size {
		switch (sizeEnum) {
			case SMALL:
				return { scaleFactor: 1, scaleX: 1, scaleY: 1 }
			case MEDIUM:
				return { scaleFactor: 2, scaleX: 2, scaleY: 2 }
			case BIG:
				return { scaleFactor: 3, scaleX: 3, scaleY: 3 }
		}
	}*/
}

/*enum SizeEnum {
	SMALL;
	MEDIUM;
	BIG;
}

typedef Size = {
	var scaleFactor: Int;
	var scaleX: Int;
	var scaleY: Int;
}*/

/*
	public enum Size {
	SMALL('A', 1, 1), MEDIUM('B', 2, 2), BIG('C', 3, 3);

	public final char scaleFactor;

	public final float scaleX;
	public final float scaleY;

	Size(char scaleFactor, float scaleX, float scaleY) {
	this.scaleFactor = scaleFactor;

	this.scaleX = scaleX;
	this.scaleY = scaleY;
	}
	}*/