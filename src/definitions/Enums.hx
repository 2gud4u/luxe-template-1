package definitions;

@:enum abstract StateNames(String) to String
{
    var Splash  = "splash";
    var Load    = "load";    
    var Level1  = "level1";
    var Level2  = "level2";    
}

@:enum abstract SplashAssets(String) to String
{
    var LetterMTexture    = "assets/texture/logo/miosis_m.png";
    var LetterITexture    = "assets/texture/logo/miosis_i.png";
    var LetterOTexture    = "assets/texture/logo/miosis_o.png";    
    var LetterSTexture    = "assets/texture/logo/miosis_s.png";        
    var LogoAnimationJson = "assets/json/animation/splash_anim.json";            
}

@:enum abstract EventTypes(String) to String
{
    var ParcelLoadFailed = "parcel_load_failed";    
    var ChangeState = "change_state";
    var StateReady = "state_ready";    
}

@:enum abstract BasicColors(Int) to Int
{
    var Black = 0x000000;
    var White = 0xffffff;  
    var Red = 0xFF0000;
    var Green = 0x00FF00;
    var Blue = 0x0000FF;  
}

// CGA palette types
@:enum abstract CGAPaletteType(String) to String
{
  var CGA0Low = "CGA0Low";
  var CGA0High = "CGA0High";
  var CGA1Low = "CGA1Low";
  var CGA1High = "CGA1High";
}

// CGA Palette 0, low intensity
@:enum abstract CGAPalette0Low(Int) to Int
{
    var Black = BasicColors.Black;
    var Cyan = 0x00aaaa;
	var Magenta = 0xaa00aa;    
	var LightGray = 0xaaaaaa;	
}

// CGA Palette 0, high intensity
@:enum abstract CGAPalette0High(Int) to Int
{
    var Black = BasicColors.Black;
    var LightCyan = 0x55ffff;
	var LightMagenta = 0xff55ff;    
	var White = BasicColors.White;	
}

// CGA Palette 1, low intensity
@:enum abstract CGAPalette1Low(Int) to Int
{
    var Black = BasicColors.Black;
    var Green = 0x00aa00;
	var Red = 0xaa0000;    
	var Brown = 0xaa5500;	
}

// CGA Palette 1, high intensity
@:enum abstract CGAPalette1High(Int) to Int
{
    var Black = BasicColors.Black;
    var LightGreen = 0x55ff55;
	var LightRed = 0xff5555;    
	var Yellow = 0xffff55;	
}

// Game Boy palette types
@:enum abstract GameBoyPaletteType(String) to String
{
    var GB1 = "GB1";
    var GB2 = "GB2";
    var GB3 = "GB3";
    var GB4 = "GB4";    
}

// Game Boy palette, gray 1
@:enum abstract GameBoyPalette1(Int) to Int
{
    var Off = BasicColors.White;
    var Light = 0xb2b2b2;
	var Medium = 0x757575;    
	var Dark = BasicColors.Black;	
}

// Game Boy palette, gray 2
@:enum abstract GameBoyPalette2(Int) to Int
{
    var Off = 0xefefef;
    var Light = 0xb2b2b2;
	var Medium = 0x757575;    
	var Dark = 0x383838;	
}

// Game Boy palette, green 1
@:enum abstract GameBoyPalette3(Int) to Int
{
    var Off = 0x9bbc0f;
    var Light = 0x8bac0f;
	var Medium = 0x306230;    
	var Dark = 0x0f380f;	
}