package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

	private var paddles:FlxTypedGroup<Paddle>;
	private var puck:Puck;
	private var logo:FlxSprite;
	private var puckSnd:FlxSound;
	private var scoreTimer:FlxTimer;
	private var s1:FlxText;
	private var s2:FlxText;

	private static inline var SPEED:Float = 200;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		add(new FlxSprite(0,0,"assets/images/bg.png"));

		paddles = new FlxTypedGroup<Paddle>();
		add(paddles);
		paddles.add(new Paddle(0));
		paddles.add(new Paddle(1));

		puck = new Puck();
		add(puck);

		add(logo = new FlxSprite(0,0,"assets/images/logo.png"));

		if(Reg.logoShown)	logo.visible = false;
		Reg.logoShown=true;
		logo.pixelPerfectRender = false;
		logo.x = FlxG.width/2 - logo.width/2;
		logo.y = FlxG.height/2- logo.height/2;

		puckSnd = new FlxSound().loadEmbedded("assets/sounds/puck.ogg");

		FlxG.watch.add(Reg,"scores", "sc");

		scoreTimer = new FlxTimer();

		s1 = new FlxText(40,40,FlxG.width-80,Reg.scores[0]==50?"adv":Reg.scores[0],32);
		s2 = new FlxText(40,40,FlxG.width-80,Reg.scores[1]==50?"adv":Reg.scores[1],32);
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
        FlxG.collide(puck, paddles, sep);


        if(puck.y < 0)
        	win(1);

        else if(puck.y > FlxG.height - puck.height)
        	win(0);

        if(FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.Q)
        	Sys.exit(0);

        if(FlxG.keys.justPressed.ENTER && paddles.members[0].usedCharge == false && puck.velocity.y < 0) {
        	puck.elasticity = 2;
        	paddles.members[0].charge();
        }

        if (FlxG.keys.justPressed.SPACE && paddles.members[1].usedCharge == false && puck.velocity.y > 0) {
        	puck.elasticity = 2;
        	paddles.members[1].charge();
        }

        if(FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) {
        	if(logo.visible == true) {
        		logo.visible = false;
        	}
        	else {
	        	start();
	        }
	    }

	    if(!scoreTimer.finished)
	    s1.y = s2.y = Math.min(35,540-scoreTimer.progress*1000);
        
	}	

	public function win(winner:Int):Void {
		FlxG.resetState();
		scoreUp(winner);
	}

	public function sep(a:FlxObject,b:FlxObject):Void {
		var dx = b.x + b.width/2 - a.x - a.width/2;
		puck.velocity.x = puck.velocity.x - dx;
		puck.elasticity = 1;

		if (puck.charged) {
			puck.velocity.x /= 2;
			puck.velocity.y /= 2;
			puck.charged = false;
		}

		puckSnd.play(true);

		if(cast(b,Paddle).charged) {
			puck.charged = true;
		}

		cast(b,Paddle).uncharge();
		FlxObject.separate(a,b);
	}

    public function start():Void {
    	if(puck.velocity.y != 0) return;
    	puck.velocity.y = puck.startAt == 0 ? -300 : 300;
    	scoreTimer = new FlxTimer(2);
    }

    public function scoreUp(_id:Int) {
    	var sc:Int = 0;
    	switch(Reg.scores[_id]) {
    		case 0:
    			sc = 15;
    		case 15:
    			sc = 30;
    		case 30:
    			sc = 40;
    		case 40:
    			if(Reg.scores[1-_id] == 40) {
    				sc = 50;
    			}
    			else if(Reg.scores[1-_id] == 50) {
    				sc = 40;
    				Reg.scores[1-_id] = 40;
    			}
    			else {
    				Reg.winner = _id;
    				FlxG.switchState(new WinState());
    			}
    		case 50:
    			Reg.winner = _id;
    			FlxG.switchState(new WinState());

    		default:
    			FlxG.log.add(Reg.scores[_id]);
    	}

    	Reg.scores[_id] = sc;
    }

}