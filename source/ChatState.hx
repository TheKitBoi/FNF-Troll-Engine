package;

import openfl.text.TextFieldType;
import openfl.display.BitmapData;
import flixel.addons.ui.FlxInputText;
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

class ChatState extends MusicBeatState
{  
    var txtbox:FlxInputText;
	override function create()
	{
        var chatTexts = new FlxTypedGroup<FlxText>();
		add(chatTexts);

        var chatText:FlxText = new FlxText(0, 60 + (1 * 160));
        chatText.ID = 1;
        chatText.screenCenter(X);
        chatTexts.add(chatText);
        chatText.scrollFactor.set();
        chatText.antialiasing = true;

        txtbox = new FlxInputText(200, 700, FlxG.width, "Type your message here...");
        txtbox.screenCenter(X);
        txtbox.background = true;
        txtbox.backgroundColor = FlxColor.WHITE;
        txtbox.borderColor = 0xFFFFFFFF;
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = 0xFFea71fd;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);
        add(txtbox);
        add(chatText);
		super.create();

	}

	override function update(elapsed:Float)
	{
        //var l = sock.input.readLine();
        super.update(elapsed);
        if(FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new MainMenuState());
        if(FlxG.keys.justPressed.ENTER) trace(txtbox.text);
	}
}
