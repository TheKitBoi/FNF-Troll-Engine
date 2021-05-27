package;
#if desktop
import sys.io.File.getContent;
#end
typedef ConfigData = {
    var width:Int;
    var height:Int;
    var fullscreen:Bool;
    var addr:String;
    var port:Int;
}

class Config {
    #if desktop
    public static var s = getContent("config.json"); //#else "{width: 1280, height: 720, fullscreen: false, addr: 'net.fnf.general-infinity.tech', port: '9000'}"; #end
    public static var data:ConfigData = haxe.Json.parse(s);
    #end
}