import luxe.Camera;
import luxe.Color;
import luxe.Input;
import luxe.Log.*;
import luxe.Parcel;
import luxe.Screen.WindowEvent;
import luxe.Sprite;
import luxe.States;
import luxe.Vector;

import phoenix.Batcher;

import mint.Canvas;
import mint.focus.Focus;
import mint.render.luxe.LuxeMintRender;

import definitions.Enums;
import components.FadeOverlay;
import states.BaseState;
import states.Load;
import states.Level1;
import states.Level2;
import states.Splash;
import ui.MiosisCanvas;

class Main extends luxe.Game  
{
    public static var mint_renderer:LuxeMintRender;
    public static var canvas:MiosisCanvas;
    public static var focus: Focus;
    public static var background_batcher: phoenix.Batcher;  
    public static var ui_batcher: phoenix.Batcher;    
    public static var foreground_camera: luxe.Camera;    
    public static var foreground_batcher: phoenix.Batcher;

    public static var w:Int = -1;
    public static var h:Int = -1;

    public static var game_scale:Float = 1.0;

    private var load_state:Load;
    private var current_state_name:String;
    private var current_parcel:Parcel;
    private var states:States;
    private var fade_overlay_sprite:Sprite;
    private var fade_overlay:FadeOverlay;
    private var changeStateEventId:String;

    override function config(config:luxe.GameConfig) 
    {
        log('Config loaded as ' + Luxe.snow.config.user);

        var windowConfig = Luxe.snow.config.user.window;
        var userConfig = Luxe.snow.config.user.game;

        w = windowConfig.width;
        h = windowConfig.height;

        game_scale = windowConfig.scale;

        config.window.width = w * cast game_scale;
        config.window.height = h * cast game_scale;

        config.window.title = windowConfig.title;
        config.window.fullscreen = windowConfig.fullscreen;
        config.window.resizable = windowConfig.resizable;
        config.window.borderless = windowConfig.borderless;

        // Load assets for the splash screen
        config.preload.textures.push({ id : "assets/texture/logo/miosis_m.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/texture/logo/miosis_i.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/texture/logo/miosis_s.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/texture/logo/miosis_o.png", filter_min:nearest, filter_mag:nearest });
        config.preload.jsons.push({ id : "assets/json/animation/splash_anim.json" });
        config.preload.jsons.push({ id : "assets/json/data/state-config.json" });        

        changeStateEventId = "";

        return config;
    }

    override function ready() 
    {
        _debug("---------- Main.ready ----------");

        var data:Array<Dynamic> = (Luxe.resources.json('assets/json/data/state-config.json').asset.json);
        log('data : ' + data); 

        // Set background color
        Luxe.renderer.clear_color = new Color().rgb(GameBoyPalette2.Dark);

        log('Main w: ${w}');
        log('Main h: ${h}');
        log('Screen width:${w} ${Luxe.screen.w}');
        log('Screen height: ${h} ${Luxe.screen.h}');

        // Fit camera viewport to window size
        Luxe.camera.size = new Vector(w, h);
        Luxe.camera.size_mode = luxe.Camera.SizeMode.fit;

        // Set up rendering
        var background_camera = new Camera({ name: 'background_camera' });
        background_camera.size = new Vector(w, h);
        background_camera.size_mode = luxe.Camera.SizeMode.fit;

        foreground_camera = new Camera({ name : 'foreground_camera' });
        foreground_camera.size = new Vector(w, h);
        foreground_camera.size_mode = luxe.Camera.SizeMode.fit;        

        background_batcher = Luxe.renderer.create_batcher({
            layer : -1,
            name :'background_batcher',
            camera : background_camera.view
        });

        ui_batcher = Luxe.renderer.create_batcher({
            layer : 1,
            name :'ui_batcher',
            camera : background_camera.view
        });

        foreground_batcher = Luxe.renderer.create_batcher({
            layer: 3,
            name:'foreground_batcher',
            camera: foreground_camera.view
        });

        mint_renderer = new LuxeMintRender({ batcher:ui_batcher });
        
        // Set up Mint canvas
        canvas = new MiosisCanvas({
            name :'canvas',
            rendering : mint_renderer,
            options : { color:new Color(1, 1, 1, 0) },
            x: 0, y:0, w: 100, h: 100
        });
        canvas.auto_listen();

        focus = new Focus(canvas);

        // Set up fade overlay
        fade_overlay_sprite = new Sprite({
            batcher : foreground_batcher,
            parent : Luxe.camera,
            name : 'fade_overlay_sprite',
            size : Luxe.screen.size,
            color : new Color().rgb(GameBoyPalette2.Dark),
            centered : false,
            depth : 990
        });     
        fade_overlay = fade_overlay_sprite.add(new FadeOverlay());
        
        // Subscribe to state change events
        changeStateEventId = Luxe.events.listen(EventTypes.ChangeState, on_change_state);

        // Go to first state
        states = new States({ name:'states' });
        load_state = states.add(new Load());
        states.add(new Splash());
        states.add(new Level1());
        states.add(new Level2());        

        current_state_name = "splash";
        states.set(current_state_name);

        var state:BaseState = cast states.current_state;
        fade_overlay.fade_in(state.fade_in_time, on_fade_in_done);      
    }

    function on_change_state(e)
    {
        _debug("---------- Main.on_change_state, go to state: " + e.state + "----------");

        current_state_name = e.state;
        
        if (current_state_name == 'load')
        {
            current_parcel = e.parcel;
        }
        else
        {
            current_parcel = null;
        }

        var state:BaseState = cast states.current_state;

        if (state.fade_out_time > 0)
        {
            fade_overlay.fade_out(state.fade_in_time, on_fade_out_done);    
        }
        else
        {
            on_fade_out_done();
        }
    }

    function on_fade_in_done()
    {
        _debug("---------- Main.on_fade_in_done ----------");

        var state:BaseState = cast states.current_state;
        _debug(state);
        state.post_fade_in();
    }

    function on_fade_out_done()
    {
        _debug("---------- Main.on_fade_out_done ----------");

        Luxe.scene.empty();

        // Destroy unused resources
        if (current_state_name == 'load')
        {
            if (current_parcel == null)
            {// Previous state was splash => assets were loaded in config
                Luxe.resources.destroy("assets/img/logo/miosis_m.png");
                Luxe.resources.destroy("assets/img/logo/miosis_i.png");
                Luxe.resources.destroy("assets/img/logo/miosis_s.png");
                Luxe.resources.destroy("assets/img/logo/miosis_o.png");
                Luxe.resources.destroy("assets/json/miosis_anim.json");
            }
            else
            {// Previous state was not splash => assets were loaded from a parcel
                current_parcel.unload();
            }

            // TODO: Set filename according to some config file
            load_state.state_to_load = 'level1';
        }

        states.set(current_state_name);

        var state:BaseState = cast states.current_state;
        fade_overlay.fade_in(state.fade_in_time, on_fade_in_done);
    }

    override function onkeyup(e:luxe.Input.KeyEvent) 
    {
        if(e.keycode == Key.escape) 
        {
            Luxe.shutdown();
        }
    }

    override function onwindowsized( e:WindowEvent ) 
    {
        Luxe.camera.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
        foreground_camera.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
    }

    override function ondestroy() 
    {
        Luxe.events.unlisten(changeStateEventId);

        if (states != null)
        {
            states.destroy();
            states = null;            
        }

        if (current_parcel != null)
        {
            current_parcel.unload();
            current_parcel = null; 
        }

        load_state = null;
        current_state_name = null;
        fade_overlay_sprite = null;
        fade_overlay = null;
    }
}
