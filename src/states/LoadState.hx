package states;

import luxe.Color;
import luxe.Log.*;
import luxe.Parcel;
import luxe.Sprite;
import luxe.Vector;
import luxe.Visual;

import luxe.resource.Resource;

import snow.api.Promise;

import definitions.Enums;
import states.BaseState;

class LoadState extends BaseState 
{
    public static var state_to_load:String;

    private var progress_bar:Sprite;
    private var progress_border:Visual;
    private var background:Sprite;

    private var width:Float = 0;
    private var height:Float = 0;

    public function new() 
    {
        _debug("---------- Load.new ----------");

        state_to_load = "";

        super({ 
            name : StateNames.Load, 
            transition_in_time : 0.2, 
            transition_out_time : 0.2 
        });
    }

    override function onenter<T>(_:T) 
    {
        _debug("---------- Load.onenter ----------");

        // Set background color

        Luxe.renderer.clear_color = new Color().rgb(BasicColors.Red);

        var view_width : Float = Luxe.screen.w;
        var view_height : Float = Luxe.screen.h;

        if (Luxe.camera.size != null) 
        {
            view_width = Luxe.camera.size.x;
            view_height = Luxe.camera.size.y;
        }

        var view_mid_x = Math.floor(view_width / 2);

        width = Math.max(Math.floor(view_width * 0.75), 2);
        height = Math.max(Math.floor(view_height * 0.002), 2);

        var y_pos = Math.floor(view_height * 0.60);
        var half_width = Math.floor(width / 2);
        var half_height = Math.floor(height / 2);

        background = new Sprite({
            name : "background", 
            scene : Main.main_scene,  
            size : new Vector(view_width, view_height),
            centered : false,
            color : new Color().rgb(GameBoyPalette2.Dark),
            depth : 1,
            visible : true,
        });

        progress_bar = new Sprite({
            name : "bar",  
            scene : Main.main_scene,
            pos : new Vector(view_mid_x - half_width, y_pos - half_height),
            size : new Vector(2, height),
            centered : false,
            color : new Color().rgb(GameBoyPalette2.Off),
            depth : 2
        });

        progress_border = new Visual({
            name : "border",
            scene : Main.main_scene,
            color : new Color().rgb(GameBoyPalette2.Medium),
            pos : new Vector(view_mid_x - half_width, y_pos - half_height),
            geometry : Luxe.draw.rectangle({
                w : width,
                h : height,
                depth : 3
            }),
            depth : 3
        });

        var promise_json:Promise = Luxe.resources.load_json("assets/json/parcel/parcel_" + state_to_load + ".json");
        promise_json.then(load_assets, json_load_failed);

        _debug(Main.main_scene);
               
        super.onenter(_);       
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Load.onleave ----------");
        
        // Clean up
        progress_bar.destroy();
        progress_bar = null;
        progress_border.destroy();
        progress_border = null;
        background.destroy();
        background = null;

        super.onleave(_data);
    }

    function load_assets(json:JSONResource) 
    {
        _debug("---------- Load.load_assets ----------");

        var parcel:Parcel = new Parcel();
        parcel.from_json(json.asset.json);

        parcel.on(ParcelEvent.progress, onprogress);
        parcel.on(ParcelEvent.complete, oncomplete);
        
        parcel.load();        
    }

    function json_load_failed(json:JSONResource) 
    {
        _debug("---------- Load.json_load_failed ----------");

        Luxe.shutdown();
    }

    function onprogress(change:ParcelChange ) 
    {
        _debug("---------- Load.onprogress ----------");

        var amount = change.index / change.total;
        set_progress(amount);
    }

    function oncomplete(parcel:Parcel)
    {
        _debug("---------- Load.oncomplete ----------");

        Luxe.events.fire(EventTypes.ChangeState, { state : state_to_load, parcel : parcel });
    }

    function set_progress(amount:Float) 
    {
        _debug("---------- Load.set_progress ----------");

        if (amount < 0) 
        {
            amount = 0;
        }

        if (amount > 1)
        {
            amount = 1;
        }

        progress_bar.size.x = Math.ceil(width * amount);
    }
}