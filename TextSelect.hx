package;

import aze.display.TileLayer;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;


/**
 * ...
 * @author Henry D. Fernández B.
 */
class TextSelect extends Select
{	
	static public var NAME : String = "UITextSelect";
	static public var XML : String = "textselect";
	
	private var textField : TextField;
	private var activeTxtColor : ColorTransform;
    private var pressTxtColor : ColorTransform;
	private var size : Int;
	
	public function new(id : String, tileLayer : TileLayer, x : Float, y : Float,fontId : String, onPressHandlerName : String, options : Array<Option>,currentOption : Int, font : Font = null, size : Int = 0, activeColor : Int = 0xFFFFFF, pressColor : Int = 0xFFFFFF, activeSprite : String, pressSprite : String, letterSpacing : Int = 0) 
	{
		super(NAME,id, tileLayer, x, y, onPressHandlerName,options,currentOption,activeColor,pressColor,activeSprite,pressSprite);
		
		//Text states colors
        var activeHexColor = MathHelper.HexToRGB(activeColor);
        var pressedHexColor = MathHelper.HexToRGB(pressColor);
		
        this.activeTxtColor = new ColorTransform(activeHexColor[0],activeHexColor[1],activeHexColor[2]);
        this.pressTxtColor = new ColorTransform(pressedHexColor[0], pressedHexColor[1], pressedHexColor[2]);
		
		this.size = size;
		if (currentOption >= 0 && currentOption < options.length)
		{
			textField = TextManager.CreateText(fontId, options[currentOption].GetValue(),new Point(x,y),size, activeColor);
			tileLayer.view.addChild(textField);
		}
	}
	
	override public function ChangeState(state : UIObject.State):Void 
	{
		
		if (state != this.state && textField != null)
		{
			switch(state)
			{
				case Active:
					textField.transform.colorTransform = activeTxtColor;
				case Pressed:
					textField.transform.colorTransform = pressTxtColor;
				default:
			}
		}
		
		super.ChangeState(state);
	}
	
	override public function ChangeCurrentOption(option:String):Void 
	{
		super.ChangeCurrentOption(option);
		
		textField.text = options[currentOption].GetValue();
	}
	
	override public function OnActionHandler():Void 
	{
		super.OnActionHandler();
		
		if (currentOption + 1 < options.length)
			currentOption++;
		else
			currentOption = 0;
		
		textField.text = options[currentOption].GetValue();
	}
	
	public function ChangeFont(fontId : String) : Void
	{
		//textField.setTextFormat(new TextFormat(fontId));
		textField.defaultTextFormat = new TextFormat(fontId);
		//textField = TextManager.CreateText(fontId, options[currentOption].GetValue(),new Point(x,y),size, activeColor);
	}
}