package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;

class Retry extends FlxSubState
{
	var pressTxt:FlxText;

	public function new(score:Int)
	{
		super();

		FlxG.sound.music.stop();
		FlxG.sound.playMusic("assets/music/Menu.wav");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		pressTxt = new FlxText("Retry?", 32);
		pressTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		pressTxt.alpha = 0.6;
		// pressTxt.x = 50;
		pressTxt.screenCenter(X);
		pressTxt.y = FlxG.height - pressTxt.height - 50;
		add(pressTxt);

		var title:FlxText = new FlxText("Best Score: " + score, 20);
		title.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		title.screenCenter(X);
		title.y = 50;
		add(title);

		FlxTween.tween(title, {"scale.x": title.scale.x + 0.2, "scale.y": title.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(pressTxt))
		{
			pressTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				FlxG.resetState();

				FlxG.sound.music.stop();
				FlxG.sound.playMusic("assets/music/Camaleon.mp3");
			}
		}
		else
		{
			pressTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}
	}
}