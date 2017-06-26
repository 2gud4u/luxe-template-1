package states;

import luxe.Color;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Vector;

import luxe.components.sprite.SpriteAnimation;

import definitions.Enums;
import components.LetterOAnimation;
import system.GameBoyPalette;

class SplashState extends BaseState 
{
	var o_anim:SpriteAnimation;
	var letters:haxe.ds.Vector<Sprite>;

	public function new() 
	{
        _debug("---------- Splash.new ----------");

        super({ 
            name:StateNames.Splash, 
            transition_in_time:0.2,
            transition_out_time:0.2 
        });
        
        letters = new haxe.ds.Vector<Sprite>(6);
    }

	override function onenter<T>(_:T) 
	{
        _debug("---------- Splash.onenter ----------");
               
        super.onenter(_);	
        _backgroundSprite.color = GameBoyPalette.get_color(3);               

        // Compute character sprite positions
        var halfscreen_width = Main.w * 0.5;
        var distance = 4;
        var width_total = 3 * 16 + 2 * 4 + 32 + 5 * distance;
        var width_total_half = 0.5 * width_total;

        // M
        var pos_x = halfscreen_width - width_total_half + 8;

        letters[0] = new Sprite({
            name:' miosis_m',
            scene:_scene,
            texture:Luxe.resources.texture('assets/texture/logo/miosis_m.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0)
        });

        // I
        pos_x += 8 + distance + 2;

        letters[1] = new Sprite({
            name:'miosis_i1', 
            scene:_scene,           
            texture:Luxe.resources.texture('assets/texture/logo/miosis_i.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0)
        });

        // O
        pos_x += 2 + distance + 16;

        letters[2] = new Sprite({
            name:'miosis_o',   
            scene:_scene,                     
            texture:Luxe.resources.texture('assets/texture/logo/miosis_o.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0),
            size:new Vector(32, 32)
        });

        // S
        pos_x += 16 + distance + 8;

        letters[3] = new Sprite({
            name:'miosis_s',  
            scene:_scene,                      
            texture:Luxe.resources.texture('assets/texture/logo/miosis_s.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0),
        });

        // I
        pos_x += 8 + distance + 2;

        letters[4] = new Sprite({
            name:'miosis_i2',  
            scene:_scene,                      
            texture:Luxe.resources.texture('assets/texture/logo/miosis_i.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0),
        });

        // S
        pos_x += 2 + distance + 8;

        letters[5] = new Sprite({
            name:'miosis_s2',    
            scene:_scene,                    
            texture:Luxe.resources.texture('assets/texture/logo/miosis_s.png'),
            pos:new Vector(pos_x, Main.h * 0.5),
            color:GameBoyPalette.get_color(0),
        });

        o_anim = letters[2].add(new LetterOAnimation({ name:'anim'}));
        o_anim.entity.events.listen('animation.splash.end', on_anim_done);           
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Splash.onleave ----------");

        o_anim = null;

        for (i in 0 ... letters.length)
        {
            letters[i].destroy();
            letters[i] = null;              
        }

        letters = null;
        
        super.onleave(_data);
    }

    override function post_fade_in()
    {
        _debug("---------- Splash.post_fade_in ----------");
        
    }

    function on_anim_done(e)
    {
        _debug("---------- Splash.on_anim_done ----------");

        o_anim.entity.events.unlisten('animation.splash.end');
        Luxe.events.fire(EventTypes.ChangeState, { state:StateNames.Level1 });
    }
}
