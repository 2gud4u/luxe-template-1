package states;

import luxe.Log.*;
import luxe.resource.Resource.AudioResource;

import mint.Button;

import definitions.Enums;
import system.GameBoyPalette;

class Level2State extends BaseState 
{
    var button:Button;
    var music:AudioResource;
    var music_handle:luxe.Audio.AudioHandle;

	public function new() 
	{
        _debug("---------- Level2State.new ----------");

        super({ name:StateNames.Level2 });
    }

	override function onenter<T>(_:T) 
	{
        _debug("---------- Level2State.onenter ----------");

        super.onenter(_);
        _backgroundSprite.color = GameBoyPalette.get_color(0);

        var colors = 
        {
            background_color:GameBoyPalette.get_color(2),
            background_color_hover:GameBoyPalette.get_color(1),
            background_color_down:GameBoyPalette.get_color(3),
            foreground_color:GameBoyPalette.get_color(3),
            foreground_color_hover:GameBoyPalette.get_color(2),
            foreground_color_down:GameBoyPalette.get_color(2),
            text_color:GameBoyPalette.get_color(0),
            text_color_hover:GameBoyPalette.get_color(0),
            text_color_down:GameBoyPalette.get_color(1)            
        };

        button = new Button({
            parent:Main.canvas, 
            name:'button', 
            text:'two',
            rendering:Main.mint_renderer,
            x:0.1 * Main.w, 
            y:0.1 * Main.h, 
            w:20, 
            h:15,
            options: { color_scheme:colors },
            onclick:function(e,c) { on_button_click(); }
        });
        button.focus();
        _debug("screen pos : " + Luxe.screen.cursor.pos);

        // Set up level music
        music = Luxe.resources.audio('assets/sound/POL-king-of-coins-short.wav');        
        // music_handle = Luxe.audio.loop(music.source);
    }

    private function on_button_click()
    {
        _debug("---------- Level2State.on_button_click ----------");

        Luxe.events.fire(EventTypes.ChangeState, { state:StateNames.Level1 });
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Level2State.onleave ----------");

        super.onleave(_data);

        button.destroy();

        // Luxe.audio.stop(music_handle);
    }

    override function post_fade_in()
    {
        _debug("---------- Level2State.post_fade_in ----------");

        // DO STUFF
    }
}
