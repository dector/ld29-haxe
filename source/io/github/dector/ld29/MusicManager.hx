package io.github.dector.ld29;

import flixel.system.FlxSound;

class MusicManager {

	private static var _instance: MusicManager;

	public static var instance(get, null): MusicManager;

	public static inline function get_instance(): MusicManager {
		if (_instance == null) {
			_instance = new MusicManager();
		}

		return _instance;
	}

	private var muted: Bool;

	private var music: FlxSound;

	private var pausedSoft: Bool;

	private function new() {
		// FIXME sheet HaxeFlixel don't support mp3 for native apps
		music = new FlxSound().loadEmbedded("assets/music.mp3", true, false);
		music.volume = 0.7;
	}

	public function play(): Void {
		if (muted)
			return;

		music.play();
	}

	public function pause(): Void {
		music.pause();
	}

	public function switchMute(): Void {
		setMuted(! muted);
	}

	public function setMuted(muted: Bool): Void {
		this.muted = muted;

		if (muted) {
			pause();
		} else {
			play();
		}
	}

	public function isMuted(): Bool {
		return muted;
	}

	public function volumeUp(): Bool {
		setMuted(false);

		music.volume += 0.1;

		return music.volume != 1;
	}

	public function volumeDown(): Bool {
		music.volume -= 0.1;

		if (music.volume == 0) {
			setMuted(true);
		}

		return music.volume != 0;
	}

	public function pauseSoft(): Void {
		if (! muted) {
			pausedSoft = true;
			pause();
		}
	}

	public function playSoft(): Void {
		if (pausedSoft) {
			pausedSoft = false;
			play();
		}
	}
}
