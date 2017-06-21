package system;

import luxe.Color;
import luxe.Log.*;

import definitions.Enums;

class CGAPalette
{
    private var _paletteType:CGAPaletteType;
    private var _palette:haxe.ds.Vector<Color>;

	public function new(type:CGAPaletteType) 
	{
        _palette = new haxe.ds.Vector<Color>(4);
        set_palette_type(type);
    }

    public function get_palette_type():CGAPaletteType
    {
        return _paletteType;
    }
    
    public function set_palette_type(type:CGAPaletteType):Void
    {
        _paletteType = type;
        
        switch (type)
        {
            case CGA0Low:
            {
                _palette[0] = new Color().rgb(CGAPalette0Low.Black);
                _palette[1] = new Color().rgb(CGAPalette0Low.Cyan);
                _palette[2] = new Color().rgb(CGAPalette0Low.Magenta);                
                _palette[3] = new Color().rgb(CGAPalette0Low.LightGray);
            } 
            case CGA0High:
            {
                _palette[0] = new Color().rgb(CGAPalette0High.Black);
                _palette[1] = new Color().rgb(CGAPalette0High.LightCyan);
                _palette[2] = new Color().rgb(CGAPalette0High.LightMagenta);                
                _palette[3] = new Color().rgb(CGAPalette0High.White);
            } 
            case CGA1Low:
            {
                _palette[0] = new Color().rgb(CGAPalette1Low.Black);
                _palette[1] = new Color().rgb(CGAPalette1Low.Green);
                _palette[2] = new Color().rgb(CGAPalette1Low.Red);                
                _palette[3] = new Color().rgb(CGAPalette1Low.Brown);
            } 
            case CGA1High:
            {
                _palette[0] = new Color().rgb(CGAPalette1High.Black);
                _palette[1] = new Color().rgb(CGAPalette1High.LightGreen);
                _palette[2] = new Color().rgb(CGAPalette1High.LightRed);                
                _palette[3] = new Color().rgb(CGAPalette1High.Yellow);
            }                                     
            default :
            {
                throw "Unknown CGA palette type " + type;
            }
        }
    }

    public function get_color(index:Int):Color
    {
        if (index > _palette.length - 1)
        {
            _debug("Palette index " + index + "out of range. Returning debug color.");

            return new Color().rgb(0xff69b4);
        }

        return _palette[index];
    }
}