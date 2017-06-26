package system;

import luxe.Color;
import luxe.Log.*;

import definitions.Enums;

class GameBoyPalette
{
    public var palette_size(default, null):Int;
    public var palette_type(default, set):GameBoyPaletteType;

    private static var palette:haxe.ds.Vector<Int>; // TODO : static yuck

	public function new(type:GameBoyPaletteType) 
	{
        palette_size = 4;
        palette = new haxe.ds.Vector<Int>(palette_size);
        set_palette_type(type);
    }
    
    private function set_palette_type(type:GameBoyPaletteType):GameBoyPaletteType
    {        
        switch (type)
        {
            case GB1:
            {
                palette[0] = GameBoyPalette1.Off;
                palette[1] = GameBoyPalette1.Light;
                palette[2] = GameBoyPalette1.Medium;                
                palette[3] = GameBoyPalette1.Dark;
            } 
            case GB2:
            {
                palette[0] = GameBoyPalette2.Off;
                palette[1] = GameBoyPalette2.Light;
                palette[2] = GameBoyPalette2.Medium;                
                palette[3] = GameBoyPalette2.Dark;
            } 
            case GB3:
            {
                palette[0] = GameBoyPalette3.Off;
                palette[1] = GameBoyPalette3.Light;
                palette[2] = GameBoyPalette3.Medium;                
                palette[3] = GameBoyPalette3.Dark;
            }
            default :
            {
                throw "Unknown Game Boy palette type " + type;
            }
        }

        return type;
    }

    public static function get_color(index:Int)
    {
        if (index > palette.length - 1)
        {
            _debug("Palette index " + index + "out of range. Returning default color.");

            return new Color().rgb(0xff69b4);
        }

        return new Color().rgb(palette[index]);
    }
}