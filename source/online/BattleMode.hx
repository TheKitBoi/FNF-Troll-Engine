package online;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import io.colyseus.Client;
import io.colyseus.Room;

class BattleMode extends MusicBeatState{
    var coly:Client;

    var logo:FlxSprite;
    var assets:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['matchmaking', 'join from code', 'back', 'login'];

    override function create()
        {
            var logo = new FlxSprite().loadGraphic(Paths.image('fnfnet')).screenCenter(XY);

            var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
            menuBG.color = 0xFFea71fd;
            menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
            menuBG.updateHitbox();
            menuBG.screenCenter();
            menuBG.antialiasing = true;

            var connectedtext = new FlxText(0, 0, 0, "Connected: $Offline$", 32);
            connectedtext.applyMarkup("Connected: $Offline$",
            [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "$")]);

            assets = new FlxTypedGroup<FlxSprite>();

            var tex = Paths.getSparrowAtlas('battleassets');

            for (i in 0...optionShit.length)
            {
                var menuItem:FlxSprite = new FlxSprite(60 + (i * 360), 200);
                menuItem.frames = tex;
                menuItem.animation.addByPrefix('idle', optionShit[i], 24);
                menuItem.animation.play('idle');
                menuItem.ID = i;
                //menuItem.screenCenter(X);
                assets.add(menuItem);
                menuItem.scrollFactor.set();
                menuItem.antialiasing = true;
            }

            add(menuBG);
            add(connectedtext);
            add(assets);   
            add(logo);

            var coly = new Client('ws://localhost:2567');
            coly.joinOrCreate("battle", [], Stuff, function(err, room) {
                if (err != null) {
                    trace("JOIN ERROR: " + err);
                    return;
                }
                connectedtext.applyMarkup("Connected: $Online$",
                [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "$")]);
                trace(room.state.chatHist);
                room.onMessage("message", function(message) {
                    //chatText.applyMarkup(chatText.text, [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "$")]);
                });
            });

            super.create();
        }
}