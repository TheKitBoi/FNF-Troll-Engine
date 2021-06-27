package online;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUITabMenu;
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
        ptxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		ptxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        playertxt.add(ptxt);

        var ptxt = new FlxText(p2.x, p2.y, 0, "Player 2:\nNot Ready");
        ptxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		ptxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
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

        var UI_box = new FlxUITabMenu(null, [
            {name: "tab1", label: 'Player'},
            {name: "tab2", label: 'Info'},
        ], true);
        var characters = CoolUtil.coolTextFile(Paths.txt('characterList'));
        var characterdropdown = new FlxUIDropDownMenu(0,0,FlxUIDropDownMenu.makeStrIdLabelArray(characters,true), function(character:String){
            p1 = new Character(p1.x, p1.y, characters[Std.parseInt(character)]); 
        });
		UI_box.resize(400, 200);
		UI_box.screenCenter(X);
        UI_box.y += 50;
        UI_box.x += 400;
        UI_box.selected_tab = 0;

        add(stageCurtains);
        add(p1);
        add(p2);
        add(playertxt);
        add(UI_box);
        UI_box.add(characterdropdown);
        super.create();
    }

    override function update(elapsed:Float){
        if(PlayStateOnline.startedMatch){
            LoadingOnline.loadAndSwitchState(new PlayStateOnline());
        }
        if(controls.BACK) FlxG.switchState(new FNFNetMenu());
        super.update(elapsed);
    }
}