package online;

import haxe.display.Protocol.HaxeNotificationMethod;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText.FlxTextFormat;
import io.colyseus.Client;
import io.colyseus.Room;
import Config.data;
import flixel.FlxG;

typedef SongData = {
    song:String,
    difficulty:Int,
    week:Int
}
class ConnectingState extends MusicBeatState {
    public static var songmeta:SongData;
    public static var p1name:String;
    public static var p2name:String;
    public static var conmode:String;
    public static var rooms:Room<Stuff>;
    public static var coly:Client;
    public function new(state:String, type:String, ?code:String){
        super();
        p2name = '';
        FlxG.autoPause = false;
        PlayStateOnline.assing = false;
        coly = new Client('ws://' + data.addr + ':' + data.port);
        switch(state){
            case 'battle':
                if(type == "host")
                {
                    conmode = 'host';
                    if(FlxG.save.data.username != null) p1name = FlxG.save.data.username; 
                    else p1name = "guest" + FlxG.random.int(0, 9999);
                    p2name = "";
                    FlxG.switchState(new ChooseSong());
                    coly.create("battle", [], Stuff, function(err, room) { 
                        if (err != null) {
                            trace("JOIN ERROR: " + err);
                            FlxG.switchState(new FNFNetMenu());
                            return;
                        }
                        PlayStateOnline.rooms = room;
                        ChooseSong.rooms = room;
                        LobbyState.rooms = room;
                        try{
                            room.send('recvprev', {name: p1name});
                            room.onMessage('creatematch', function(message){
                                ChooseSong.celsong = message.song;
                                ChooseSong.bruh = true;
                            });
                            room.onMessage('message', function(message){
                                if(LobbyState.code == message.iden) PlayStateOnline.onlinemodetext.text = "Player Found! Starting...";
                                LobbyState.code = message.iden;	
                            });
                            room.onMessage("misc", (message) -> {
                                if(message.p1) {
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                                if(message.p2) {
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                            });
                            room.onMessage("start", function(message){
                                PlayStateOnline.startedMatch = true;
                                remove(PlayStateOnline.onlinemodetext);
                                remove(PlayStateOnline.roomcode);
                                add(PlayStateOnline.p1scoretext);
                                add(PlayStateOnline.p2scoretext);
                                //new PlayStateOnline().starts();
                                PlayStateOnline.assing = true;
                            });
                            room.onMessage('userjoin', function(message){
                                LobbyState.p2.alpha = 1;
                                p2name = message.name;
                            });
                            room.onMessage('userleft', function(message){
                                LobbyState.p2.alpha = 0;
                                if(PlayStateOnline.startedMatch) PlayStateOnline.leftText.text = "User left the game.";
                                if(!PlayStateOnline.startedMatch)p2name = '';
                                if(!PlayStateOnline.startedMatch)LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                            });
                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = p1name + " Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = p2name + " Score: " + PlayStateOnline.p2score;
                            });
                        }catch(e:Any){
                            PlayStateOnline.connected = false;
                            trace("Could not connect to the server");
                            if(FlxG.random.bool(0.1))PlayStateOnline.onlinemodetext.text = "bitch git gud internet";
                            else PlayStateOnline.onlinemodetext.text = "Not connected to the server.";
                            PlayStateOnline.onlinemodetext.screenCenter(XY);
                        }
                    });
                }else if(type == "join"){
                    conmode = 'join';
                    if(FlxG.save.data.username != null) p2name = FlxG.save.data.username;
                    else p2name = "guest" + FlxG.random.int(0, 9999);
                    try{
                        coly.join("battle", [], Stuff, function(err, room) { 
                            if (err != null) {
                                trace("JOIN ERROR: " + err);
                                FlxG.switchState(new FNFNetMenu());
                                return;
                            }
                            LobbyState.rooms = room;
                            PlayStateOnline.rooms = room;
                            room.send('recvprev', {name: p2name});
                            room.onMessage("start", function(message){
                                LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                                PlayStateOnline.startedMatch = true;
                                //new PlayStateOnline().starts();
                                PlayStateOnline.assing = true;
                            });
                            room.onLeave += function () {

                            };
                            room.onMessage("misc", (message) -> {
                                if(message.p1) {
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                                if(message.p2) {
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                            });
                            room.onMessage('userleft', function(message){
                                LobbyState.p2.alpha = 0;
                                if(PlayStateOnline.startedMatch) PlayStateOnline.leftText.text = "User left the game.";
                                if(!PlayStateOnline.startedMatch){
                                    FlxG.switchState(new FNFNetMenu());
                                    p2name = '';
                                }
                                if(!PlayStateOnline.startedMatch)LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                            });
                            room.onMessage("message", function(message){
                                p1name = message.p1name;
                                LobbyState.songdata.song = message.song;
                                LobbyState.songdata.week = message.week;

                                var poop:String = Highscore.formatSong(message.song, 2);

                                PlayStateOnline.SONG = Song.loadFromJson(poop, message.song);
                                PlayStateOnline.isStoryMode = false;
                                PlayStateOnline.storyDifficulty = message.diff;
                    
                                PlayStateOnline.storyWeek = message.week;
                                LobbyState.songdata.difficulty = PlayStateOnline.storyDifficulty;
                                LoadingOnline.loadAndSwitchState(new LobbyState());
                            });

                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = p1name + " Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = p2name + " Score: " + PlayStateOnline.p2score;
                            });
                        });
                    }catch(e:Any){
                        trace(e);
                    }
                    //var poop:String = Highscore.formatSong("philly", 2);

                    ///PlayStateOnline.SONG = Song.loadFromJson(poop, "philly");
                    ///PlayStateOnline.isStoryMode = false;
                    ///PlayStateOnline.storyDifficulty = 2;
        
                   /// PlayStateOnline.storyWeek = 3;
                    //LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                }else if(type == "code"){
                    trace("ass");
                    try{
                        coly.joinById(code, [], Stuff, function(err, room) { 
                            if (err != null) {
                                trace("JOIN ERROR: " + err);
                                FlxG.switchState(new FNFNetMenu());
                                return;
                            }
                            LobbyState.rooms = room;
                            PlayStateOnline.rooms = room;
                            room.send('recvprev', {name: p2name});
                            room.onMessage("start", function(message){
                                LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                                PlayStateOnline.startedMatch = true;
                                //new PlayStateOnline().starts();
                                PlayStateOnline.assing = true;
                            });
                            room.onLeave += function () {

                            };
                            room.onMessage("misc", (message) -> {
                                if(message.p1) {
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[0].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                                if(message.p2) {
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GREEN), "/r/")]);
                                }else{
                                    LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                                }
                            });
                            room.onMessage('userleft', function(message){
                                LobbyState.p2.alpha = 0;
                                if(PlayStateOnline.startedMatch) PlayStateOnline.leftText.text = "User left the game.";
                                if(!PlayStateOnline.startedMatch){
                                    FlxG.switchState(new FNFNetMenu());
                                    p2name = '';
                                }
                                if(!PlayStateOnline.startedMatch)LobbyState.playertxt.members[1].applyMarkup("/r/Not Ready/r/", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "/r/")]);
                            });
                            room.onMessage("message", function(message){
                                p1name = message.p1name;
                                LobbyState.songdata.song = message.song;
                                LobbyState.songdata.week = message.week;

                                var poop:String = Highscore.formatSong(message.song, 2);

                                PlayStateOnline.SONG = Song.loadFromJson(poop, message.song);
                                PlayStateOnline.isStoryMode = false;
                                PlayStateOnline.storyDifficulty = message.diff;
                    
                                PlayStateOnline.storyWeek = message.week;
                                LobbyState.songdata.difficulty = PlayStateOnline.storyDifficulty;
                                LoadingOnline.loadAndSwitchState(new LobbyState());
                            });

                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = p1name + " Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = p2name + " Score: " + PlayStateOnline.p2score;
                            });
                        });
                    }catch(e:Any){
                        trace(e);
                    }
                }
                
        }
    }
    override function create(){
        FlxG.autoPause = false;

        super.create();
    }
    override function update(elapsed:Float){
        super.update(elapsed);
    }
}