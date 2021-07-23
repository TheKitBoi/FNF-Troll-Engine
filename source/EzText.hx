package;

import flixel.util.FlxColor;
import flixel.text.FlxText;

class EzText extends FlxText
{
    public function new(x:Float, y:Float, text:String, size:Int){
        super(x, y, 0, text);
        scrollFactor.set();
		setFormat(Paths.font('vcr.ttf'), 48);
		updateHitbox();
		setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
		antialiasing = true;
    }
    override function update(elapsed:Float){
        super.update(elapsed);
    }
}