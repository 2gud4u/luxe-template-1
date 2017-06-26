package entities;

import luxe.Log.*;
import luxe.Sprite;

import system.GameBoyPalette;

class FadeTransitionSprite extends Sprite 
{
    public function new() 
    {   
        _debug("---------- FadeTransitionSprite.new ----------");

    	super({
            name:'fade-transition-sprite',            
            batcher:Main.foreground_batcher,
            parent:Luxe.camera,
            size:Luxe.screen.size,
            color:GameBoyPalette.get_color(3),
            centered:false
        });
    }
}
