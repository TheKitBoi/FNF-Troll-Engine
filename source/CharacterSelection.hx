package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import lime.utils.Assets;
import Controls.Control;
using StringTools;

class CharacterSelection extends MusicBeatState
{
	var controlsStrings:Array<String> = ["BOYFRIEND"];
	var curChar:FlxSprite;
	var grpControls:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	override function create()
	{
		//Assets.loadLibrary("shared");
		curChar = new FlxSprite(30, 30);
		curChar.frames = Paths.getSparrowAtlas("BOYFRIEND");
		curChar.animation.addByPrefix("idle", 'BF idle dance', 24, true);

		var carlist = Assets.getText(Paths.txt("CustomCharacters"));
		var pissArray:Array<String> = carlist.split('\n');
		for (i in 0...pissArray.length){
			controlsStrings.push(pissArray[i]); 
		}
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = 0xFFea71fd;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;

		curChar.animation.play("idle");
		add(menuBG);
		add(curChar);
		
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			//controlLabel.isMenuItem = true;
			controlLabel.x += (600);
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
		if(controls.ACCEPT){
			var stopspamming:Bool = false;
			if (stopspamming == false)
			{
				var daSelected:String = controlsStrings[curSelected];
				curChar.frames = Paths.getSparrowAtlas(daSelected);
				curChar.animation.addByPrefix("hey", 'BF HEY!!', 24, false);
				curChar.animation.play("hey");
				FlxG.sound.play(Paths.sound('confirmMenu'));
				stopspamming = true;
			}
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
		}

	}
	function changeSelection(change:Int = 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = grpControls.length - 1;
			if (curSelected >= grpControls.length)
				curSelected = 0;
	
			// selector.y = (70 * curSelected) + 30;
	
			var bullShit:Int = 0;
	
			for (item in grpControls.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
			#if target.threaded
			sys.thread.Thread.create(() -> {
				var daSelected:String = controlsStrings[curSelected];
				curChar.frames = Paths.getSparrowAtlas(daSelected);
				curChar.animation.addByPrefix("idle", 'BF idle dance', 24, true);
				curChar.animation.play("idle");
			});
			#else 
			var daSelected:String = controlsStrings[curSelected];
			curChar.frames = Paths.getSparrowAtlas(daSelected);
			curChar.animation.addByPrefix("idle", 'BF idle dance', 24, true);
			curChar.animation.play("idle");
			#end
		}
	function waitingInput():Void
		{
			if (FlxG.keys.getIsDown().length > 0)
			{
				PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
			}
			// PlayerSettings.player1.controls.replaceBinding(Control)
		}
		
		var isSettingControl:Bool = false;
	
		function changeBinding():Void
		{
			if (!isSettingControl)
			{
				isSettingControl = true;
			}
		}
}
