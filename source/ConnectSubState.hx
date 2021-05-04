import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.client.UDProteanClient;

class NetClient extends UDProteanClient
{
    // Called after the constructor.
    override function initialize() { }

    // Called after the connection handshake.
    override function onConnect() {
        ChatState.chatText.text = "";
     }

    override function onMessage(message: Bytes) { 
        trace(message);
        if(message==Bytes.ofString("QUITTHETHING")){
            FlxG.switchState(new MainMenuState());
        } 
        ChatState.chatText.text = ChatState.chatText.text + Std.string(message) + "\n";
    }
    override function onDisconnect() { 
        FlxG.switchState(new MainMenuState());
    }
}