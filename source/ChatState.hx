package;

import haxe.io.Bytes;
import ConnectSubState.NetClient;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import udprotean.client.UDProteanClient;
import Config.data;

class ChatState extends MusicBeatState
{  
    public static var client:NetClient;

    var txtbox:FlxInputText;

    public static var messages:FlxText;
	public static var chatText:FlxText;

    override function create()
	{
        FlxG.mouse.visible = true;
        client = new NetClient(data.addr, data.port);
        client.connect();
        var chatTexts = new FlxTypedGroup<FlxText>();
		add(chatTexts);

        chatText = new FlxText(FlxG.width * 0.01, 0, 0, "Loading...", 32);
        chatText.ID = 1;
        //chatText.screenCenter(X);
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
        client.update();
        //var l = sock.input.readLine();
        super.update(elapsed);
        if(FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new MainMenuState());
        if(FlxG.keys.justPressed.ENTER) {
            client.send(Bytes.ofString(txtbox.text), true); //Bytes.ofString(txtbox.text)
            txtbox.text = "";
            txtbox.caretIndex = 0;
        }
	}
}
