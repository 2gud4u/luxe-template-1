package dk.miosis.luxetemplate.entities;

import luxe.Sprite;
import luxe.Vector;

class Player extends Sprite {

    public function new() {    	
    	super({
            texture:Luxe.resources.texture('assets/img/smiley.png'),
            pos:new Vector(Main.w * 0.5, Main.h * 0.5),
            depth:4
        });
    }
}