package dk.miosis.luxetemplate.component;

import luxe.Color;
import luxe.Sprite;

class FadeOverlay extends luxe.Component 
{
    var overlay:Sprite;

    override function init() 
    {
        overlay = new Sprite({
            size: Luxe.screen.size,
            color: new Color(0,0,0,1),
            centered: false,
            depth:99
        });
    }

    public function fade_in(?t=0.15,?fn:Void->Void) 
    {
        overlay.color.tween(t, {a:0}).onComplete(fn);
    }

    public function fade_out(?t=0.15,?fn:Void->Void) 
    {
        overlay.color.tween(t, {a:1}).onComplete(fn);
    }

    override function ondestroy() 
    {
        overlay.destroy( );
    }
}