package system;

import luxe.Color;
import luxe.Log.*;

import definitions.Enums;

class GameBoyPalette
{
    public var palette_type(default, set):GameBoyPaletteType;
    private static var _palette:haxe.ds.Vector<Color>; // TODO : static yuck

	public function new(type:GameBoyPaletteType) 
	{
        _palette = new haxe.ds.Vector<Color>(4);
        set_palette_type(type);
    }
    
    public function set_palette_type(type:GameBoyPaletteType):GameBoyPaletteType
    {        
        switch (type)
        {
            case GB1:
            {
                _palette[0] = new Color().rgb(GameBoyPalette1.Off);
                _palette[1] = new Color().rgb(GameBoyPalette1.Light);
                _palette[2] = new Color().rgb(GameBoyPalette1.Medium);                
                _palette[3] = new Color().rgb(GameBoyPalette1.Dark);
            } 
            case GB2:
            {
                _palette[0] = new Color().rgb(GameBoyPalette2.Off);
                _palette[1] = new Color().rgb(GameBoyPalette2.Light);
                _palette[2] = new Color().rgb(GameBoyPalette2.Medium);                
                _palette[3] = new Color().rgb(GameBoyPalette2.Dark);
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
        if (index > _palette.length - 1)
        {
            _debug("Palette index " + index + "out of range. Returning default color.");

            return new Color().rgb(0xff69b4);
        }

        return _palette[index];
    }
}