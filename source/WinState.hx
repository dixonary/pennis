package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class WinState extends FlxState
{
    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        add(new FlxSprite(0,0,"assets/images/bg.png"));

        Reg.logoShown = false;

        var winTxt = Reg.winner == 0 ? "the top wins" : "the bottom wins";
        var t:FlxText;
        add(t=new FlxText(0,0, FlxG.width, winTxt, 40));
        t.color = 0xffff69b4;
        t.alignment="center";
        t.x = FlxG.width/2-t.width/2;
        t.y = FlxG.height/2-t.height;


        var s1 = new FlxText(40,40,FlxG.width-80,Reg.scores[0]==50?"adv":Reg.scores[0],32);
        var s2 = new FlxText(40,40,FlxG.width-80,Reg.scores[1]==50?"adv":Reg.scores[1],32);
        s2.alignment="right"; 
        s1.color = s2.color = 0xffff69b4;
        add(s1);
        add(s2);
    }
    
    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();
    }   
}