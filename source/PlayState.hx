package;

import chameleon.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;
import openfl.Lib;

class PlayState extends FlxState
{
	private var chameleon:Chameleon;

	private var flies:FlxTypedGroup<Fly>;
	private var areaFlies:FlxTypedGroup<FlxSprite>;

	private var health:Int = 3;
	private var healthTxt:FlxText /* = "3"*/;

	private var score:Int = 0;
	private var scoreTxt:FlxText /* = "Score: 0"*/;
	private var scoreGrp:FlxTypedGroup<FlxText>;

	// private var areaReference:FlxSprite;
	private var level:Int = 1;

	override public function create()
	{
		FlxG.camera.bgColor = 0xFFFFFFFF;

		super.create();
		chameleon = new Chameleon();
		chameleon.setPosition(FlxG.width - chameleon.width - 50, FlxG.height - chameleon.height - 50);
		add(chameleon);

		add(areaFlies = new FlxTypedGroup());
		add(flies = new FlxTypedGroup());

		scoreTxt = new FlxText("Score: 0", 32);
		scoreTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(scoreTxt);

		healthTxt = new FlxText("3", 32);
		healthTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.RED, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(healthTxt);

		scoreTxt.x = FlxG.width - scoreTxt.width - 15;
		scoreTxt.y = 15;

		healthTxt.x = FlxG.width - healthTxt.width - 15;
		healthTxt.y = scoreTxt.y + scoreTxt.height + 15;

		// add(scoreGrp = new FlxTypedGroup());

		// var index = -1;
		// areaReference = new FlxSprite().makeGraphic(Std.int(flies.members[0].width), Std.int(flies.members[0].height), FlxColor.RED);
		// areaReference.alpha = 0.6;
	}

	var timer:Float = 0;

	var waitTime:Float = 5.2;
	var waitRandom:Float = 1;

	// var flyIndex:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		scoreTxt.text = "Score: " + score;
		healthTxt.text = "" + health;

		scoreTxt.x = FlxG.width - scoreTxt.width - 15;
		scoreTxt.y = 15;

		healthTxt.x = FlxG.width - healthTxt.width - 15;
		healthTxt.y = scoreTxt.y + scoreTxt.height + 15;

		if (timer == 0 && waitTime < 3)
			waitRandom = FlxG.random.float(1, 2);

		timer += elapsed;

		if (timer >= waitTime / waitRandom)
		{
			var fly = new Fly(FlxG.random.float(1, 2.5), this);
			// fly.ID;

			var area = new FlxSprite().makeGraphic(Std.int(fly.width), Std.int(fly.height), 0x8CFF0000);
			area.setPosition(fly.destiny.x, fly.destiny.y);

			fly.area = area;

			areaFlies.add(area);
			flies.add(fly);

			timer = 0;
			if (waitTime >= 0.55)
				waitTime -= 0.15;
		}

		FlxG.watch.addQuick("DJSKD", timer);
		FlxG.watch.addQuick("DJSKD max", waitTime / waitRandom);

		var isCursor:Bool = false;

		for (area in areaFlies)
		{
			area.angle += elapsed * 15;
		}

		for (fly in flies)
		{
			// timer += elapsed * 100;
			// fly.updateBeat(timer);

			if (fly.active && fly.visible)
			{
				// areaFlies.members[fly.ID].setPosition(fly.destiny.x, fly.destiny.y);
				// areaFlies.members[fly.ID].visible = true;
				// areaFlies.members[fly.ID].alpha += (0.6 - areaFlies.members[fly.ID].alpha) * (elapsed * 6);

				if (FlxG.mouse.overlaps(fly.area))
				{
					isCursor = true;
					// Lib.current.stage.window.cursor = POINTER;
					if (FlxG.mouse.justPressed
						&& fly.x >= (fly.destiny.x - (15 * fly.speed))
						&& fly.y >= (fly.destiny.y - (15 * fly.speed)))
					{
						fly.onFlyHitted();
						chameleon.animation.play("attack");
						//
						var rating:FlxText = new FlxText("+100");
						rating.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.BLACK, LEFT, OUTLINE_FAST, FlxColor.WHITE);
						rating.y = FlxG.mouse.y - (rating.height / 2);
						rating.x = FlxG.mouse.x - (rating.width / 2);
						add(rating);

						FlxTween.tween(rating, {y: rating.y - 50}, 1, {
							onComplete: (_) ->
							{
								rating.kill();
								remove(rating);
							}
						});

						score += 100;
					}
				}
			}
		}

		if (chameleon.animation.finished && chameleon.animation.name == "attack")
			chameleon.animation.play("idle");

		if (isCursor)
			Lib.current.stage.window.cursor = POINTER;
		else
			Lib.current.stage.window.cursor = DEFAULT;
	}

	public function whenFlyKilled(fly:Fly):Void
	{
		flies.remove(fly);

		areaFlies.remove(fly.area);

		// var rating:FlxText = new FlxText("100");
	}

	public function onFlyFailed(fly:Fly):Void
	{
		var rating:FlxText = new FlxText("-1");
		rating.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.RED, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		rating.y = FlxG.mouse.y - (rating.height / 2);
		rating.x = FlxG.mouse.x - (rating.width / 2);
		add(rating);

		FlxTween.tween(rating, {y: rating.y - 50}, 1, {
			onComplete: (_) ->
			{
				rating.kill();
				remove(rating);
			}
		});

		health--;

		areaFlies.remove(fly.area);
	}
}
