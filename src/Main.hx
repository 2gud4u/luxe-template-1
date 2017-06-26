import luxe.Camera;
import luxe.Color;
import luxe.Input;
import luxe.Log.*;
import luxe.Scene;
import luxe.Screen.WindowEvent;
import luxe.Vector;

import phoenix.Batcher;

import mint.focus.Focus;
// import mint.render.luxe.LuxeMintRender;

import definitions.Enums;
import system.GameBoyPalette;
import system.StateManager;
import ui.UICanvas;
import ui.UIRendering;

class Main extends luxe.Game  
{
    public static var main_scene:Scene;
    public static var mint_renderer:UIRendering;
    public static var canvas:UICanvas; // TODO : does this need to be public static
    public static var focus:Focus; // TODO : does this need to be public static
    public static var background_batcher:phoenix.Batcher;  
    public static var ui_batcher: phoenix.Batcher;    
    public static var foreground_batcher:phoenix.Batcher;
    public static var palette:GameBoyPalette;

    public static var w:Int = -1;
    public static var h:Int = -1;

    public static var game_scale:Float = 1.0;
    public static var game_scale_inverse:Float = 1.0;    

    private var _state_manager : StateManager;

    override function config(config:luxe.GameConfig) 
    {
        log('Config loaded as ' + Luxe.snow.config.user);

        var windowConfig = Luxe.snow.config.user.window;
        var renderingConfig = Luxe.snow.config.user.rendering;

        // for (n in Reflect.fields(renderingConfig))
        //     trace("BLAMMO : " + Reflect.field(renderingConfig, n));

        // Init palette

        palette = new GameBoyPalette(renderingConfig.palette);

        w = windowConfig.width;
        h = windowConfig.height;

        game_scale = windowConfig.scale;
        game_scale_inverse = 1 / game_scale;

        config.window.width = w * cast game_scale;
        config.window.height = h * cast game_scale;

        config.window.title = windowConfig.title;
        config.window.fullscreen = windowConfig.fullscreen;
        config.window.resizable = windowConfig.resizable;
        config.window.borderless = windowConfig.borderless;

        // Load assets for the splash screen
        config.preload.textures.push({ id : LetterMTexture, filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : LetterITexture, filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : LetterOTexture, filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : LetterSTexture, filter_min:nearest, filter_mag:nearest });
        config.preload.jsons.push({ id : LogoAnimationJson });

        return config;
    }

    override function ready() 
    {
        _debug("---------- Main.ready ----------");

        // Set background color
        
	    Luxe.renderer.clear_color = new Color().rgb(BasicColors.Red);        

        log('Main w: ${w}');
        log('Main h: ${h}');
        log('Screen width:${w} ${Luxe.screen.w}');
        log('Screen height: ${h} ${Luxe.screen.h}');

        // Create main scene

        main_scene = new Scene("main_scene");

        // Set up cameras and batchers

        Luxe.camera.size = new Vector(w, h);
        Luxe.camera.size_mode = luxe.Camera.SizeMode.fit;

        var background_camera = new Camera({ name: 'background_camera' });
        background_camera.size = new Vector(w, h);
        background_camera.size_mode = luxe.Camera.SizeMode.fit;

        var foreground_camera = new Camera({ name : 'foreground_camera' });
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
        
        // Set up Mint canvas

        mint_renderer = new UIRendering({ batcher:ui_batcher });

        canvas = new UICanvas({
            name :'canvas',
            rendering : mint_renderer,
            options : { color:new Color(1, 1, 1, 0) },
            x: 0, y:0, w: 100, h: 100
        });
        canvas.auto_listen();

        focus = new Focus(canvas);

        // Start state manager

        _state_manager = new StateManager();
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
        foreground_batcher.view.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
    }

    override function ondestroy() 
    {
        _state_manager.destroy();
    }
}
