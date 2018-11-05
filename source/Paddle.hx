package;

import flixel.FlxSprite;
import flixel.FlxG;

class Paddle extends FlxSprite {

    public static inline var ACCN:Float = 3000;
    public var origY:Float;
    public var id:Int;
    public var usedCharge:Bool = false;
    public var charged = false;

    public function new(_id:Int):Void {
        super(0,0);

        loadGraphic("assets/images/paddle.png", true,20,5,true); 

        scale.x = scale.y = 5;
        updateHitbox();

        elasticity = 1;
        immovable = true;

        id=_id;
        maxVelocity.x = 400;
        origY = 100;
        drag.x = ACCN;

        x = FlxG.width/2-width/2;
        y = _id==0?30:FlxG.height-height-30;

        FlxG.watch.add(FlxG.keys.pressed, "LEFT", "left");

    }

    public function charge():Void {
        charged = true;
        usedCharge = true;
        animation.frameIndex = 1;
    }

    public function uncharge():Void {
        animation.frameIndex = 0;
        charged = false;
    }


    override public function update():Void {
        super.update();
        if(id==0?FlxG.keys.pressed.LEFT:FlxG.keys.pressed.A)
            acceleration.x = -ACCN;
        else if(id==0?FlxG.keys.pressed.RIGHT:FlxG.keys.pressed.D)
            acceleration.x = ACCN;
        else
            acceleration.x = 0;

        if(x < 0) {
            velocity.x = Math.abs(velocity.x)/2;
            x = 0;
        }
        else if(x > FlxG.width - width) {
            velocity.x = -Math.abs(velocity.x)/2;
            x = FlxG.width - width;
        }

    }


}