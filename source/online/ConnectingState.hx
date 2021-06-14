package online;

import io.colyseus.Client;
import io.colyseus.Room;
import Config.data;
import flixel.FlxG;

class ConnectingState extends MusicBeatState {
    public static var rooms:Room<Stuff>;
    public static var coly:Client;
    public function new(state:String){
        super();
        coly = new Client('ws://' + data.addr + ':' + data.port);
        switch(state){
            case 'battle':
                coly.joinOrCreate("battle", [], Stuff, function(err, room) { 
                    PlayStateOnline.rooms = room;
                    ChooseSong.rooms = room;
                    try{
                        room.onMessage('creatematch', function(message){
                            var poop:String = Highscore.formatSong(message.song, 2);
    
                            PlayStateOnline.SONG = Song.loadFromJson(poop, message.song);
                            PlayStateOnline.isStoryMode = false;
                            PlayStateOnline.storyDifficulty = 2;
                    
                            PlayStateOnline.storyWeek = 1;
                            LoadingOnline.loadAndSwitchState(new PlayStateOnline());
                        });
                        room.onMessage('message', function(message){
                            PlayStateOnline.code = message.iden;	
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
                
        }
    }
    override function create(){
        
        super.create();
    }
    override function update(elapsed:Float){
        super.update(elapsed);
    }
}