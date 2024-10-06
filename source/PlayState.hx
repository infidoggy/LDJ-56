package;

import chameleon.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;
import openfl.Lib;

class PlayState extends FlxState
{
	private var chameleon:Chameleon;

	private var flies:FlxTypedGroup<Fly>;
	private var numFlies:FlxTypedGroup<FlxText>;
	private var areaFlies:FlxTypedGroup<FlxSprite>;

	// private var areaReference:FlxSprite;
	private var level:Int = 1;

	private var file:FliesFile;

	override public function create()
	{
		file = cast Json.parse(Assets.getText('assets/data/level' + level + '.json'));

		FlxG.camera.bgColor = 0xFFFFFFFF;

		super.create();
		chameleon = new Chameleon();
		chameleon.setPosition(FlxG.width - chameleon.width - 50, FlxG.height - chameleon.height - 50);
		add(chameleon);

		add(flies = new FlxTypedGroup());
		add(numFlies = new FlxTypedGroup());
		add(areaFlies = new FlxTypedGroup());

		// var index = -1;

		for (index => time in file.flies)
		{
			var fly:Fly = new Fly(time, this);
			fly.ID = index;
			flies.add(fly);

			var area:FlxSprite = new FlxSprite().makeGraphic(Std.int(flies.members[0].width), Std.int(flies.members[0].height), FlxColor.RED);
			area.alpha = 0.6;
			area.visible = false;
			areaFlies.add(area);

			trace(time);
		}

		// areaReference = new FlxSprite().makeGraphic(Std.int(flies.members[0].width), Std.int(flies.members[0].height), FlxColor.RED);
		// areaReference.alpha = 0.6;
	}

	var timer:Float = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		var isCursor:Bool = false;

		for (fly in flies)
		{
			timer += elapsed * 100;
			fly.updateBeat(timer);

			if (fly.active && fly.visible)
			{
				areaFlies.members[fly.ID].setPosition(fly.destiny.x, fly.destiny.y);
				areaFlies.members[fly.ID].visible = true;
				areaFlies.members[fly.ID].alpha += (0.6 - areaFlies.members[fly.ID].alpha) * (elapsed * 6);

				if (FlxG.mouse.overlaps(areaFlies.members[fly.ID]))
				{
					isCursor = true;
					// Lib.current.stage.window.cursor = POINTER;
					if (FlxG.mouse.justPressed
						&& fly.x >= (fly.destiny.x - (15 * fly.speed))
						&& fly.y >= (fly.destiny.y - (15 * fly.speed)))
					{
						fly.onFlyHitted();
					}
				}
			}
		}

		if (isCursor)
			Lib.current.stage.window.cursor = POINTER;
		else
			Lib.current.stage.window.cursor = DEFAULT;
	}

	public function whenFlyKilled(fly:Fly):Void
	{
		flies.remove(fly);

		areaFlies.remove(areaFlies.members[fly.ID]);
	}
}
