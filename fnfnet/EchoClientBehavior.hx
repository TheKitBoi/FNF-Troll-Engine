import sys.net.Address;
import udprotean.shared.Utils;
import cpp.Lib;
import haxe.io.Bytes;
import udprotean.server.UDProteanClientBehavior;

class EchoClientBehavior extends UDProteanClientBehavior
{
    // Called after the constructor.
    override function initialize() { }

    // Called after the connection handshake.
    override function onConnect() { 
        
        Lib.print("Someone has Connected.\n");
    }

    override function onMessage(message: Bytes) {
        if(message==Bytes.ofString("/quit")){
            send(Bytes.ofString("QUITTHETHING"));
        }
        Lib.print("User: " + message + "\n");
        send(message);
    }

    override function onDisconnect() { }
}