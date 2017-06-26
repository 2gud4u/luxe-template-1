package states;

import luxe.Color;
import luxe.Log.*;
import luxe.options.StateOptions;
import luxe.Scene;
import luxe.Sprite;
import luxe.States;
import luxe.Vector;

import definitions.Enums;
import system.GameBoyPalette;

typedef BaseStateOptions = 
{
    > StateOptions,
    @:optional var transition_in_time:Float;
    @:optional var transition_out_time:Float;
}

class BaseState extends State 
{
    public var transition_in_time:Float;
    public var transition_out_time:Float;

    private var _scene :Scene;
    private var _backgroundSprite:Sprite;

    public function new(_options:BaseStateOptions) 
    {
        _debug("---------- BaseState.new ----------");

        def(_options.transition_in_time, 1);
        def(_options.transition_out_time, 1);

        transition_in_time = _options.transition_in_time;
        transition_out_time = _options.transition_out_time;

        super(_options);
    }

    override function onenter<T>(_:T) 
    {
        _debug("---------- BaseState.onenter ----------");

        super.onenter(_);       

        _scene = new Scene(this.name);  

        var view_width:Float = Luxe.screen.w;
        var view_height:Float = Luxe.screen.h;

        if (Luxe.camera.size != null) 
        {
            view_width = Luxe.camera.size.x;
            view_height = Luxe.camera.size.y;
        }

        _backgroundSprite = new Sprite({
            name:"background", 
            scene:_scene,  
            batcher:Main.background_batcher,
            size:new Vector(view_width, view_height),
            centered:false,
            depth:1,
            visible:true,
        });

        // Luxe.events.fire(EventTypes.StateReady, { state :name });
    }

    override function onleave<T>(_:T) 
    {
        _debug("---------- BaseState.onleave ----------");

        if (Luxe.core.shutting_down)
        {
            return;
        }

        if (_backgroundSprite != null)
        {
            _backgroundSprite.destroy();
            _backgroundSprite = null;
        }

        _scene.empty();

        if (!_scene.destroyed)
        {
            _scene.destroy();
        }

        _scene = null;
    }

    public function post_fade_in()
    {
        // DO STUFF
    }
}
