package io.github.dector.ld29;

import flixel.effects.particles.FlxParticle;

class Bubble extends FlxParticle {

	public function new() {
		super();

		loadGraphic("assets/bubble.png");
        antialiasing = true;

		exists = false;
	}
}