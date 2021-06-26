package online;

import flixel.text.FlxText;
import haxe.MainLoop;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.graphics.cairo.CairoPattern;
import io.colyseus.Room;

class LobbyState extends MusicBeatState{
    var rooms:Room<Stuff>;
    var p1:Character;
    var p2:Character;
    var playertxt:FlxTypedGroup<FlxSprite>;

    override function create(){
        p1 = new Character(180, 303);
        p2 = new Character(660, 303);
        playertxt = new FlxTypedGroup<FlxSprite>();
        var ptxt = new FlxText(p1.x, p1.y, 0, "Player 1:\nNot Ready");
        playertxt.add(ptxt);

        var ptxt = new FlxText(p2.x, p2.y, 0, "Player 2:\nNot Ready");
        playertxt.add(ptxt);

        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
        bg.antialiasing = true;
        bg.scrollFactor.set(0.9, 0.9);
        bg.active = false;
        add(bg);

        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
        stageFront.updateHitbox();
        stageFront.antialiasing = true;
        stageFront.scrollFactor.set(0.9, 0.9);
        stageFront.active = false;
        add(stageFront);

        var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.antialiasing = true;
        stageCurtains.scrollFactor.set(1.3, 1.3);
        stageCurtains.active = false;

        add(stageCurtains);
        add(p1);
        add(p2);
        add(playertxt);
        super.create();
    }

    override function update(elapsed:Float){
        if(PlayStateOnline.startedMatch){
            LoadingOnline.loadAndSwitchState(new PlayStateOnline());
        }
        super.update(elapsed);
    }
}