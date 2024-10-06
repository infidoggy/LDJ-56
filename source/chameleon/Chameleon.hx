package chameleon;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Chameleon extends FlxSprite
{
	// TENGO UN DIA 😭😭😭😭
	public function new()
	{
		super();

		var path = "assets/images/CHAMELEON_SPRITE_SHEET";

		frames = FlxAtlasFrames.fromSparrow(path + ".png", path + ".xml");
		animation.addByPrefix("idle", "CHAMELEON LIL DANCE0", 24, false);
		animation.addByPrefix("attack", "CHAMELEON ATTACK0", 24, false);
		animation.play("idle");

		setGraphicSize(Std.int(width * 0.65));
	}
}
