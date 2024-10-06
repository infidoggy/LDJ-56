package chameleon;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Tongue extends FlxSprite
{
	public function new()
	{
		super();

		var path = "assets/images/Chameleon tongue";

		frames = FlxAtlasFrames.fromSparrow(path + ".png", path + ".xml");
		animation.addByPrefix("idle", "TONGUE0", 24, false);

		animation.play("idle");

		// updateHitbox();
		// centerOffsets();

		visible = false;
	}
}