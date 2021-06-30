package online;

import flixel.addons.ui.FlxUI;
import flixel.ui.FlxButton;
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

typedef Boolean = Bool; //doing this just to piss off haya :troll:
class LobbyState extends MusicBeatState{
    public static var rooms:Room<Stuff>;
    var p1:Character;
    var p2:Character;
    var readybtn:FlxButton;
    var ready:Boolean = false;
    public static var playertxt:FlxTypedGroup<FlxText>;

    override function create(){
        p1 = new Character(180, 303);
        p2 = new Character(660, 303);
        playertxt = new FlxTypedGroup<FlxText>();
        var ptxt = new FlxText(p1.x, p1.y, 0, "Not Ready");
        ptxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		ptxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        ptxt.applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
        playertxt.add(ptxt);

        var ptxt = new FlxText(p2.x, p2.y, 0, "Not Ready");
        ptxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
		ptxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        ptxt.applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
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
        readybtn = new FlxButton(50, 50, "Ready", function(){
            ready = !ready;
            if(ready) readybtn.text = "Unready";
            else readybtn.text = "Ready";
            //rooms.send("misc", {ready: ready});
        });
		UI_box.resize(400, 200);
		UI_box.screenCenter(X);
        UI_box.y += 50;
        UI_box.x += 400;
        UI_box.selected_tab = 0;

        var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "tab1";
		//tab_group_song.add(UI_songTitle);
        //tab_group.add(characterdropdown);
        tab_group.add(readybtn);
        UI_box.addGroup(tab_group);
        add(stageCurtains);
        add(p1);
        add(p2);
        add(playertxt);
        add(UI_box);

        super.create();
    }

    override function update(elapsed:Float){
        if(PlayStateOnline.startedMatch){
            LoadingOnline.loadAndSwitchState(new PlayStateOnline());
        }
        if(controls.BACK) {
            rooms.leave();
            FlxG.switchState(new FNFNetMenu());
        }
        super.update(elapsed);
    }
}