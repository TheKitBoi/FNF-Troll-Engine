package;

import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import Controls.Control;
using StringTools;

class CharacterSelection extends MusicBeatState
{
	var controlsStrings:Array<String> = ["BOYFRIEND", "ritz", ];
	var curChar:FlxSprite;
	
	var grpControls:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	override function create()
	{
		//Assets.loadLibrary("shared");
		var blackBarThingie:FlxSprite = new FlxSprite(0, 500).makeGraphic(FlxG.width, 400, FlxColor.BLACK);
		
		curChar = new FlxSprite(30, 30);
		curChar.frames = Paths.getSparrowAtlas("BOYFRIEND");
		curChar.animation.addByPrefix("idle", 'BF idle dance', 24, true);
		curChar.screenCenter(X);
		
		var carlist = Assets.getText(Paths.txt("CustomCharacters"));
		var pissArray:Array<String> = carlist.split('\n');

		for (i in 0...pissArray.length){
			//controlsStrings.push(pissArray[i]); 
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
		add(blackBarThingie);
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, 0, controlsStrings[i], true, false);
			controlLabel.screenCenter(XY);
			controlLabel.y += 200;
			//controlLabel.isMenuItem = true;
			controlLabel.y += ((controlLabel.height + 20) * i);
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
			/*
			var tmp = grpControls.members[curSelected].x;
			grpControls.members[curSelected] = new Alphabet(0, grpControls.members[curSelected].y, "ping!", true, false);
			grpControls.members[curSelected].x = tmp;
			*/
			var stopspamming:Bool = false;
			if (stopspamming == false)
			{
				var daSelected:String = controlsStrings[curSelected];
				curChar.animation.addByPrefix("hey", 'BF HEY!!', 24, false);
				curChar.animation.play("hey");
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.save.data.curcharacter = daSelected;
				FlxG.save.flush();
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
			/*
			if(curSelected > 2){
				var tmp = grpControls.members[curSelected].x;
				grpControls.members[curSelected] = new Alphabet(0, grpControls.members[curSelected].y, controlsStrings[curSelected], true, false);
				grpControls.members[curSelected].x = tmp;
			}
			*/
			trace(curSelected);
			trace(controlsStrings);
			var daSelected:String = controlsStrings[curSelected];
			curChar.frames = Paths.getSparrowAtlas(daSelected);
			curChar.animation.addByPrefix("idle", 'BF idle dance', 24, true);
			curChar.animation.play("idle");
			//grpControls.forEach()
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
