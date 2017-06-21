package ui.render;

import luxe.Color;
import luxe.Log.*;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;

import mint.Button;
import mint.Control;
import mint.render.Render;
import mint.types.Types.MouseEvent;

import definitions.Enums;
import ui.UIRendering;

private typedef SimpleButtonColorScheme = 
{
    var background_color:Color;
    var background_color_hover:Color;
    var background_color_down:Color;
    var foreground_color:Color;
    var foreground_color_hover:Color;
    var foreground_color_down:Color;  
    var text_color:Color;
    var text_color_hover:Color;
    var text_color_down:Color;       
}

class UIButtonSimple extends Render 
{
    private var _background:Sprite;
    private var _foreground:Sprite;
    private var _text:Text;
    private var _color_scheme:SimpleButtonColorScheme;    

    public function new(uiRendering:UIRendering, control:Button) 
    {
        _debug("---------- UIButtonSimple.new ----------");

        super(rendering, control);

        rendering = uiRendering;
        var labelRenderer:mint.render.luxe.Label = cast control.label.renderer;
        _text = labelRenderer.text;
        var opt = control.options.options;

        def(opt.color_scheme, {});
        def(opt.color_scheme.background_color, new Color().rgb(BasicColors.Red));
        def(opt.color_scheme.background_color_hover, new Color().rgb(BasicColors.Red));
        def(opt.color_scheme.background_color_down, new Color().rgb(BasicColors.Red));
        def(opt.color_scheme.foreground_color, new Color().rgb(BasicColors.Green));                 
        def(opt.color_scheme.foreground_color_hover, new Color().rgb(BasicColors.Green));
        def(opt.color_scheme.foreground_color_down, new Color().rgb(BasicColors.Green));
        def(opt.color_scheme.text_color, new Color().rgb(BasicColors.Blue));
        def(opt.color_scheme.text_color_hover, new Color().rgb(BasicColors.Blue));
        def(opt.color_scheme.text_color_down, new Color().rgb(BasicColors.Blue));                

        _color_scheme = opt.color_scheme;

        // Init visuals

        _background = new Sprite({
            name:"button.background", 
            scene:uiRendering.scene,
            batcher:uiRendering.options.batcher,
            depth:uiRendering.options.depth + control.depth,
            visible:control.visible,
            centered:false
        });        

        _foreground = new Sprite({
            name:"button.foreground", 
            scene:uiRendering.scene,
            batcher:uiRendering.options.batcher,
            depth:uiRendering.options.depth + control.depth,
            visible:control.visible,
            centered:false
        });

        // Subscribe to mouse events

        control.onmouseenter.listen(on_mouse_enter);
        control.onmouseleave.listen(on_mouse_leave);
        control.onmousedown.listen(on_mouse_down);
        control.onmouseup.listen(on_mouse_up);
        control.onmousemove.listen(on_mouse_move); 

        // Set size and appearance
        onbounds();
        check_current_mouse_position();
    }

    override function onbounds():Void
    {
        _background.pos = new Vector(control.x, control.y);
        _background.size = new Vector(control.w, control.h);
        
        var border_thickness = 0.5;  
        var foreground_width = _background.size.x - 2 * border_thickness;
        var foreground_height = _background.size.y - 2 * border_thickness;  

        _foreground.pos = new Vector(control.x + border_thickness, control.y + border_thickness);
        _foreground.size = new Vector(foreground_width, foreground_height);
    }

    override function onvisible(_visible:Bool):Void
    {
        _debug("---------- UIButtonSimple.onvisible ----------");

        _background.visible = _visible;      
        _foreground.visible = _visible;              
    }

    override function ondepth(depth:Float):Void
    {
        var uiRendering = cast rendering;
        _background.depth = uiRendering.options.depth + depth;
        _foreground.depth = _background.depth + 1;        
    }

    override function ondestroy():Void
    {
        // Unsubscribe from mouse events

        control.onmouseenter.remove(on_mouse_enter);
        control.onmouseleave.remove(on_mouse_leave);
        control.onmousedown.remove(on_mouse_down);
        control.onmouseup.remove(on_mouse_up);
        control.onmousemove.remove(on_mouse_move);  

        // Destroy visuals

        if (!_background.destroyed)
        {
            _background.destroy();
        }

        if (!_foreground.destroyed)
        {
            _foreground.destroy();
        }

        _background = null;
        _foreground = null; 
        _text = null;
        _color_scheme = null;
    }

    public function check_current_mouse_position():Void
    {
        var unscaled_x = Luxe.screen.cursor.pos.x * Main.game_scale_inverse;
        var unscaled_y = Luxe.screen.cursor.pos.y * Main.game_scale_inverse;

        if (control.contains(unscaled_x, unscaled_y))
        {
            set_hover_colors();
        }
        else
        {
            set_normal_colors();
        }
    }

    private function set_normal_colors():Void
    {
        _background.color = _color_scheme.background_color;                 
        _foreground.color = _color_scheme.foreground_color;        
        _text.color = _color_scheme.text_color;        
    }

    private function set_hover_colors():Void
    {
        _background.color = _color_scheme.background_color_hover;         
        _foreground.color = _color_scheme.foreground_color_hover;        
        _text.color = _color_scheme.text_color_hover;        
    }

    private function set_down_colors():Void
    {
        _background.color = _color_scheme.background_color_down;        
        _foreground.color = _color_scheme.foreground_color_down;
        _text.color = _color_scheme.text_color_down;        
    }

    private function on_mouse_enter(e:MouseEvent, c:Control):Void
    {
        // _debug("---------- UIButtonSimple.on_mouse_enter ----------");
        set_hover_colors();
    }

    function on_mouse_leave(e:MouseEvent, c:Control) 
    {
        // _debug("---------- UIButtonSimple.on_mouse_leave ----------");

        set_normal_colors();
    }

    function on_mouse_down(e:MouseEvent, c:Control) 
    {
        // _debug("---------- UIButtonSimple.on_mouse_down ----------");        

        set_down_colors();
    }

    function on_mouse_up(e:MouseEvent, c:Control) 
    {
        // _debug("---------- UIButtonSimple.on_mouse_up ----------");

        if (e.button == none) 
        {
            // Outside button
            // _debug("OUTSIDE!!!!!!!!!!!!!!");
            set_normal_colors();
        }   
        else
        {
            // Inside button
            // _debug("INSIDE!!!!!!!!!!!!!!");            
            set_hover_colors();
        }    
    }

    function on_mouse_move(e:MouseEvent, c:Control) 
    {
        // _debug("---------- UIButtonSimple.on_mouse_move ----------");
    }

    // override function onfocused()
    // {
    //     set_hover_colors();
    // }
}
