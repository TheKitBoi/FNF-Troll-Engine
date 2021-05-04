package;
import sys.io.File.getContent;

typedef ConfigData = {
    var width:Int;
    var height:Int;
    var fullscreen:Bool;
    var addr:String;
    var port:Int;
}

class Config {
    public static var s = getContent("config.json");
    public static var data:ConfigData = haxe.Json.parse(s);
}