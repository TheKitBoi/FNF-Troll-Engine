package;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxSave;
import Controls.KeyboardScheme;
class OptionsMenu extends MusicBeatState
{
	public static var _gameSave:FlxSave;
	public static var notice:FlxText;
	public static var resolution:FlxText;
	public static var fullscreen:FlxText;
	public static var curFPS:FlxText;
	public static var downscroll:FlxText;
	public static var ks:FlxText;
	public static var rn:Int;
	public static var cDat:Int;
	public static var kbd:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];
	var cockjoke:Int = FlxG.updateFramerate;
	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{

		//FlxG.save.bind('funkin', 'trollengine');
		_gameSave = new FlxSave(); // initialize
		_gameSave.bind("options");

		switch(_gameSave.data.ks){
			case null:
				kbd = "WASD";
			case "WASD":
				kbd = "WASD";
			case "DFJK":
				kbd = "DFJK";
		}

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = ["Framerate", "Pause on Unfocus", "Fullscreen", "Downscroll", "Keyboard Scheme", "Click me for funny!"];// nop3CoolUtil.coolTextFile(Paths.txt('controls'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		notice = new FlxText(20, FlxG.height * 0.83, 0, "", 32);
		notice.text = "Use the left and arrow keys to change this option!";
		notice.scrollFactor.set();
		notice.setFormat(Paths.font('vcr.ttf'), 32);
		notice.updateHitbox();
		notice.screenCenter(X);
		notice.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(notice);
		notice.alpha=0;

		curFPS = new FlxText(20, 15 + 0, 0, "", 32);
		curFPS.text = "Current Framerate: " + FlxG.drawFramerate;
		curFPS.scrollFactor.set();
		curFPS.setFormat(Paths.font('vcr.ttf'), 32);
		curFPS.updateHitbox();
		curFPS.x = FlxG.width - (curFPS.width + 20);
		curFPS.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(curFPS);

		resolution = new FlxText(20, 15 + 64, 0, "", 32);
		resolution.text = "Pause on Unfocus: " + FlxG.autoPause;
		resolution.scrollFactor.set();
		resolution.setFormat(Paths.font('vcr.ttf'), 32);
		resolution.updateHitbox();
		resolution.x = FlxG.width - (resolution.width + 20);
		resolution.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(resolution);

		fullscreen = new FlxText(20, 15 + 128, 0, "", 32);
		fullscreen.text = "Fullscreen: " + FlxG.fullscreen;
		fullscreen.scrollFactor.set();
		fullscreen.setFormat(Paths.font('vcr.ttf'), 32);
		fullscreen.updateHitbox();
		fullscreen.x = FlxG.width - (fullscreen.width + 20);
		fullscreen.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(fullscreen);

		downscroll = new FlxText(20, 15 + 196, 0, "", 32);
		downscroll.text = "Downscroll: " + _gameSave.data.downscroll;
		downscroll.scrollFactor.set();
		downscroll.setFormat(Paths.font('vcr.ttf'), 32);
		downscroll.updateHitbox();
		downscroll.x = FlxG.width - (fullscreen.width + 20);
		downscroll.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(downscroll);

		ks = new FlxText(20, 15 + 260, 0, "", 32);
		ks.text = "Keyboard Scheme: " + kbd;
		ks.scrollFactor.set();
		ks.setFormat(Paths.font('vcr.ttf'), 32);
		ks.updateHitbox();
		ks.x = FlxG.width - (fullscreen.width + 80);
		ks.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(ks);


		
			grpControls = new FlxTypedGroup<Alphabet>();
			add(grpControls);

			for (i in 0...controlsStrings.length)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}
		 

		super.create();

		//openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			switch(curSelected){
				case 0:
					if(controls.RIGHT_P) {
						if(FlxG.drawFramerate < 120) {
							FlxG.drawFramerate += 20; 
							FlxG.updateFramerate += 20; 
							_gameSave.data.framerate = FlxG.drawFramerate;
							_gameSave.flush();
						}
						trace(FlxG.drawFramerate);
						curFPS.text = "Current Framerate: " + FlxG.drawFramerate;
					}
					if(controls.LEFT_P) {
						if(FlxG.drawFramerate > 20) {
							FlxG.drawFramerate -= 20; 
							FlxG.updateFramerate -= 20; 
							_gameSave.data.framerate = FlxG.drawFramerate;
							_gameSave.flush();
						}
						trace(FlxG.drawFramerate);
						curFPS.text = "Current Framerate: " + FlxG.drawFramerate;
					}
				case 1:
					/* scrapped stuff, maybe work on later
					if(controls.RIGHT_P) {
						rn++;
						trace(resW[rn]);
						FlxG.resizeGame(resW[rn], resH[rn]);
						FlxG.resizeWindow(resW[rn], resH[rn]);
						FlxG.cameras.reset();
						FlxG.camera.setSize(resW[rn], resH[rn]);
						resolution.text = "Current Resolution: " + resW[rn] + "x" + resH[rn];
					}
					if(controls.LEFT_P) {
						rn--;
						FlxG.resizeGame(resW[rn], resH[rn]);
						FlxG.resizeWindow(resW[rn], resH[rn]);
						FlxG.cameras.reset();
						FlxG.camera.setSize(resW[rn], resH[rn]);
						resolution.text = "Current Resolution: " + resW[rn] + "x" + resH[rn];
					}
					*/
				case 2:
					if(controls.ACCEPT) {
						FlxG.fullscreen = !FlxG.fullscreen;
						_gameSave.data.fullscreen = FlxG.fullscreen;
						_gameSave.flush();
						fullscreen.text = "Fullscreen: " + FlxG.fullscreen;
					}
					
			}
			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				switch(curSelected){
					case 0:
						{
						FlxTween.tween(notice, {alpha: 1}, 1, {
							ease: FlxEase.quartInOut, 
							onComplete: function(twn:FlxTween)
								{
									new FlxTimer().start(2, function(timer:FlxTimer){
										if (timer.finished) {
											FlxTween.tween(notice, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
										}
									});
								}
						});
					}
					case 1:
						FlxG.autoPause = !FlxG.autoPause;
						_gameSave.data.pauseonunfocus = FlxG.autoPause;
						_gameSave.flush();
						resolution.text = "Pause on Unfocus: " + FlxG.autoPause;
					case 3:
						PlayState.downscroll = !PlayState.downscroll;
						_gameSave.data.downscroll = PlayState.downscroll;
						_gameSave.flush();
						downscroll.text = "Downscroll: " + PlayState.downscroll;
					case 4:
						if(kbd == "WASD"){
							kbd = "DFJK";
							controls.setKeyboardScheme(KeyboardScheme.Custom, true);
							_gameSave.data.ks = "DFJK";
							_gameSave.flush();
							ks.text = "Keyboard Scheme: " + kbd;
						}else{
							kbd = "WASD";
							controls.setKeyboardScheme(KeyboardScheme.Solo, true);
							_gameSave.data.ks = "WASD";
							_gameSave.flush();
							ks.text = "Keyboard Scheme: " + kbd;
						}
					case 5:
						var request = new haxe.Http("https://fnf.general-infinity.tech/thing.php");
						request.setPostData("no=no");
						request.request(true);
						FlxG.openURL('https://fnf.general-infinity.tech/thefunny.php');	
				}
			}
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
	}
}
