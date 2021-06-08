package online;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import io.colyseus.Client;
import io.colyseus.Room;
import flixel.tweens.FlxEase;
class BattleMode extends MusicBeatState{
    var coly:Client;

    var logo:FlxSprite;
    var hand:FlxSprite;

    var curSelected:Int = 0;

    var assets:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['matchmaking', 'join from code', 'back', 'login'];

    override function create()
        {
            logo = new FlxSprite().loadGraphic(Paths.image('fnfnet'));
            logo.screenCenter(XY);
            logo.antialiasing = true;
            logo.y = -160;
            logo.setGraphicSize(Std.int(logo.width / 1.6), Std.int(logo.height / 1.6));
            
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

            hand = new FlxSprite(158, 438);
            hand.frames = Paths.getSparrowAtlas('battleassets');
            hand.animation.addByPrefix('hand', 'hand', 24, true);
            hand.animation.play('hand');

            for (i in 0...Std.int(optionShit.length/2))
            {
                var menuItem:FlxSprite = new FlxSprite(305 + (i * 360), 425);
                menuItem.frames = tex;
                menuItem.animation.addByPrefix('idle', optionShit[i], 24);
                menuItem.animation.play('idle');
                menuItem.ID = i;
                //menuItem.screenCenter(X);
                assets.add(menuItem);
                menuItem.scrollFactor.set();
                menuItem.antialiasing = true;
            }
            for (i in 0...1)
                {
                    var menuItem:FlxSprite = new FlxSprite(305 + (i * 360), 550);
                    menuItem.frames = tex;
                    menuItem.animation.addByPrefix('idle', optionShit[i+2], 24);
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
            add(hand);
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
        override function update(elapsed:Float){
            super.update(elapsed);
            if(FlxG.keys.justPressed.LEFT) changeSelection(-1);
            if(FlxG.keys.justPressed.RIGHT) changeSelection(1);
            if(FlxG.keys.justPressed.UP) changeSelection(-2);
            if(FlxG.keys.justPressed.DOWN) changeSelection(2);
            if(controls.BACK) FlxG.switchState(new ChatStateNew());
            if(controls.ACCEPT){
                assets.forEach(function (spr:FlxSprite){
                    if(spr.ID != curSelected){
                        FlxTween.tween(spr, {width: 0, height: 0}, 1.5, {ease:FlxEase.quintInOut});
                    }

                });
            }
        }
        function changeSelection(change:Int = 0){
            curSelected += change;
            hand.flipX = false;
            if(curSelected < 0){
                curSelected = 0;
            }
            if(curSelected > 2){
                curSelected = 2;
            }
            hand.y = 438;
            switch(curSelected)
            {
                case 0:
                    hand.x = 167;
                case 1:
                    hand.flipX = true;
                    hand.x = 1000;
                case 2:
                    hand.x = 167;
                    hand.y = 550;
            }
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
}