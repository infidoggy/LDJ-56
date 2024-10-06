package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Fly extends FlxSprite
{
	public var time:Float = 1000;
	public var speed:Float = 1.0;

	public var destiny:FlxPoint = null;

	private var animToDestiny:FlxTween = null;

	public var parent:PlayState;

	public function new(Time:Float, Parent:PlayState)
	{
		super();

		var path = "assets/images/fly";

		parent = Parent;

		frames = FlxAtlasFrames.fromSparrow(path + ".png", path + ".xml");
		animation.addByPrefix("idle", "fly idle0", 30);
		animation.play("idle");

		time = Time;

		// velocidad aleatoria, la velocidad aumenta cada 30 segundos
		speed = (FlxG.random.float(0.8, 1.8) * (1 + (((time / 1000) / 30) / 2))) * 0.8;

		destiny = new FlxPoint(FlxG.random.float(15, (FlxG.width - width) * 0.65), FlxG.random.float(15, FlxG.height - height - 15));

		visible = active = false;
	}

	var timerToFail:Float = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (x == destiny.x && y == destiny.y)
		{
			timerToFail += elapsed;

			if (timerToFail >= 0.75)
				failFly();
		}
	}

	private function failFly():Void
	{
		active = false;

		trace("XDD" + time);

		FlxTween.tween(this, {alpha: 0}, 0.5, {
			ease: FlxEase.quadInOut,
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
			ease: FlxEase.quadInOut,
			onComplete: (_) ->
			{
				kill();
				parent.whenFlyKilled(this);
				// destroy();
			}
		});
	}

	public function updateBeat(position:Float)
	{
		visible = active = position > time - (500 / speed);

		if (active && animToDestiny == null)
			animToDestiny = FlxTween.tween(this, {x: destiny.x, y: destiny.y}, 0.5 * speed, {
				ease: FlxEase.sineInOut
			});
	}
}
