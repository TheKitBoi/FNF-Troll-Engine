package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.util.FlxBitmapDataUtil;
import flixel.FlxBasic;
import flixel.FlxObject;
import openfl.display.PNGEncoderOptions;
import lime.ui.FileDialog;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
class MusicBeatState extends FlxUIState
{
	private var topCam:FlxCamera;
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;
	var geom:flash.geom.Rectangle;
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		topCam = new FlxCamera();
		//FlxG.cameras.add(topCam);
		geom = new flash.geom.Rectangle(0, 0, FlxG.width, FlxG.height);
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.F2){	
			var bitfile = FlxScreenGrab.grab();
			var finalresult = bitfile.bitmapData.encode(bitfile.bitmapData.rect, new PNGEncoderOptions(true));
			//new FileDialog().save(finalresult, "png", null, "file");
			var screenshot = new FlxSprite(700, -200);
			screenshot.pixels = bitfile.bitmapData;
			screenshot.antialiasing = true;
			screenshot.setGraphicSize(320, 180);
			screenshot.cameras = [topCam];
			add(screenshot);
		}
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
