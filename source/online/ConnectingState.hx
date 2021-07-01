package online;

import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText.FlxTextFormat;
import io.colyseus.Client;
import io.colyseus.Room;
import Config.data;
import flixel.FlxG;

class ConnectingState extends MusicBeatState {
    public static var p1name:String;
    public static var p2name:String;
    public static var rooms:Room<Stuff>;
    public static var coly:Client;
    public function new(state:String, type:String, ?code:String){
        super();
        FlxG.autoPause = false;
        PlayStateOnline.assing = false;
        coly = new Client('ws://' + data.addr + ':' + data.port);
        switch(state){
            case 'battle':
                if(FlxG.save.data.username != null) p1name = "guest" + FlxG.random.int(0, 9999); 
                else p1name = FlxG.save.data.username;
                if(type == "host")
                {
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
                            room.onMessage('creatematch', function(message){
                                ChooseSong.celsong = message.song;
                                ChooseSong.bruh = true;
                            });
                            room.onMessage('message', function(message){
                                if(PlayStateOnline.code == message.iden) PlayStateOnline.onlinemodetext.text = "Player Found! Starting...";
                                PlayStateOnline.code = message.iden;	
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
                            room.onMessage('userjoin' function(message){
                                p2name = message.name;
                            });
                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = "Player 1 Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = "Player 2 Score: " + PlayStateOnline.p2score;
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
                    trace("ass");
                    try{
                        coly.join("battle", [], Stuff, function(err, room) { 
                            if (err != null) {
                                trace("JOIN ERROR: " + err);
                                FlxG.switchState(new FNFNetMenu());
                                return;
                            }
                            LobbyState.rooms = room;
                            PlayStateOnline.rooms = room;
                            room.onMessage("start", function(message){
                                LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                                PlayStateOnline.startedMatch = true;
                                //new PlayStateOnline().starts();
                                PlayStateOnline.assing = true;
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
                            room.onMessage("message", function(message){
                                var poop:String = Highscore.formatSong(message.song, 2);

                                PlayStateOnline.SONG = Song.loadFromJson(poop, message.song);
                                PlayStateOnline.isStoryMode = false;
                                PlayStateOnline.storyDifficulty = message.diff;
                    
                                PlayStateOnline.storyWeek = message.week;
                                
                                LoadingOnline.loadAndSwitchState(new LobbyState());
                            });

                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = "Player 1 Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = "Player 2 Score: " + PlayStateOnline.p2score;
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
                            PlayStateOnline.rooms = room;
                            if (err != null) {
                                trace("JOIN ERROR: " + err);
                                FlxG.switchState(new FNFNetMenu());
                                return;
                            }
                            room.onMessage("start", function(message){
                                LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                                PlayStateOnline.startedMatch = true;
                                //new PlayStateOnline().starts();
                                PlayStateOnline.assing = true;
                            });
                            room.onMessage("message", function(message){
                                var poop:String = Highscore.formatSong(message.song, 2);

                                PlayStateOnline.SONG = Song.loadFromJson(poop, message.song);
                                PlayStateOnline.isStoryMode = false;
                                PlayStateOnline.storyDifficulty = message.diff;
                    
                                PlayStateOnline.storyWeek = message.week;
                                LoadingOnline.loadAndSwitchState(new LobbyState());
                            });

                            room.onMessage("retscore", function(message){
                                PlayStateOnline.p1score = message.p1score;
                                PlayStateOnline.p2score = message.p2score;

                                PlayStateOnline.p1scoretext.text = "Player 1 Score: " + PlayStateOnline.p1score;
                                PlayStateOnline.p2scoretext.text = "Player 2 Score: " + PlayStateOnline.p2score;
                            });
                            room.onError += function(code, message){
                                FlxG.switchState(new FNFNetMenu());
                            }
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