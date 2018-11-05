package;

import flixel.FlxSprite;
import flixel.FlxG;

class Puck extends FlxSprite {

    public var startAt:Int;
    public var charged:Bool = false;

    public function new():Void {
        super(0);

        makeGraphic(100,100,0x0083F52C);

        flixel.util.FlxSpriteUtil.drawCircle(this,50,50,50,0xff99f500);

        elasticity = 1;
        pixelPerfectRender = false;

        scale.x = scale.y =0.2;
        updateHitbox();

        startAt = Math.round(Math.random());

        x = FlxG.width/2 - width/2;
        y = startAt == 0 ? 100-height/2 : FlxG.height-height/2-100;
    }

    override public function update():Void {
        super.update();

        if(x < 0) {
            velocity.x = Math.abs(velocity.x)/2;
            x = 0;
        }
        else if(x > FlxG.width - width) {
            velocity.x = -Math.abs(velocity.x)/2;
            x = FlxG.width - width;
        }
        velocity.y *= 1.001;

    }
}