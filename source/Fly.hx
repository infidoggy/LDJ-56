package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Fly extends FlxSprite
{
	public var speed:Float = 1.0;

	public var destiny:FlxPoint = null;

	public var area:FlxSprite;

	// private var animToDestiny:FlxTween = null;

	public var parent:PlayState;

	public var canInteract:Bool = true;

	public function new(Speed:Float, Parent:PlayState)
	{
		super();

		var path = "assets/images/fly";

		parent = Parent;

		frames = FlxAtlasFrames.fromSparrow(path + ".png", path + ".xml");
		animation.addByPrefix("idle", "fly idle0", 30);
		animation.play("idle");

		// velocidad aleatoria, la velocidad aumenta cada 30 segundos
		// speed = (FlxG.random.float(0.8, 1.8) * (1 + (((time / 1000) / 30) / 2))) * 0.8;
		speed = Speed;
		
		destiny = new FlxPoint(FlxG.random.float(15, (FlxG.width - width) * 0.45), FlxG.random.float(30, FlxG.height - height - 30));

		FlxTween.tween(this, {x: destiny.x, y: destiny.y}, 0.5 * speed, {
			ease: FlxEase.sineInOut
		});

		// visible = active = false;
	}

	var timerToFail:Float = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (x == destiny.x && y == destiny.y)
		{
			timerToFail += elapsed;

			if (timerToFail >= 1)
				failFly();
		}
	}

	private function failFly():Void
	{
		// active = false;
		canInteract = false;
		parent.onFlyFailed(this);

		FlxTween.tween(this, {y: -height}, 1.2, {
			ease: FlxEase.quadIn,
			onComplete: (_) ->
			{
				kill();
				parent.whenFlyKilled(this);
				// destroy();
			}
		});
	}

	public function onFlyHitted():Void
	{
		active = false;

		FlxTween.tween(this, {alpha: 0, "scale.x": scale.x + 0.3, "scale.y": scale.y + 0.3}, 0.5, {
			ease: FlxEase.sineInOut,
			onComplete: (_) ->
			{
				parent.whenFlyKilled(this);
				kill();
				// destroy();
			}
		});
	}

	// public function updateBeat(position:Float)
	// {
	// 	visible = active = position > time - (500 / speed);

	// 	if (active && animToDestiny == null)
	// 		animToDestiny = FlxTween.tween(this, {x: destiny.x, y: destiny.y}, 0.5 * speed, {
	// 			ease: FlxEase.sineInOut
	// 		});
	// }
}
