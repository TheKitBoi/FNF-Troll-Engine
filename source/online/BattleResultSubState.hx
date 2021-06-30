package online;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
class BattleResultSubState extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
    var loseorwin:FlxText;
	var aktc:Alphabet;
	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		super();
		var camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		aktc = new Alphabet(FlxG.width * 0.001, FlxG.height * 0.95, "Press any key to continue", true);
		aktc.cameras = [camHUD];
        //if(Math.max(PlayStateOnline.p1score, PlayStateOnline.p2score))
        loseorwin = new FlxText(FlxG.width * 0.01, 60, "Final Score:\nPlayer 1: " + PlayStateOnline.p1score + "\nPlayer 2: " + PlayStateOnline.p2score, 32);
		//loseorwin.font = Paths.font('fnf');
		Conductor.songPosition = 0;
		loseorwin.cameras = [camHUD];
		bf = new Boyfriend(x, y, daBf);
		add(bf);
		
		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);
		add(loseorwin);
		add(aktc);
		FlxG.sound.playMusic(Paths.music('breakfast'));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		//FlxG.camera.scroll.set();
		//FlxG.camera.target = null;

		bf.playAnim('idle');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new online.FNFNetMenu());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('breakfast'));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;
}