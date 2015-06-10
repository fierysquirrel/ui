package fs.ui;

import aze.display.TileLayer;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.text.Font;
import flash.text.TextField;
import fs.helper.MathHelper;

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
	
	public function new(id : String, tileLayer : TileLayer, x : Float, y : Float, onPressHandlerName : String, options : Array<Option>,currentOption : Int, font : Font = null, size : Int = 0, activeColor : Int = 0xFFFFFF, pressColor : Int = 0xFFFFFF, activeSprite : String, pressSprite : String, letterSpacing : Int = 0) 
	{
		super(NAME,id, tileLayer, x, y, onPressHandlerName,options,currentOption,activeColor,pressColor,activeSprite,pressSprite);
		
		//Text states colors
        var activeHexColor = MathHelper.HexToRGB(activeColor);
        var pressedHexColor = MathHelper.HexToRGB(pressColor);
		
        this.activeTxtColor = new ColorTransform(activeHexColor[0],activeHexColor[1],activeHexColor[2]);
        this.pressTxtColor = new ColorTransform(pressedHexColor[0], pressedHexColor[1], pressedHexColor[2]);
		
		if (currentOption >= 0 && currentOption < options.length)
		{
			//TODO: Revisar esto
			//textField = Helper.CreateText(font.fontName, Helper.Translate(options[currentOption].GetName()), size, activeColor,letterSpacing,new Point(x,y));
			//tileLayer.view.addChild(textField);
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
		//TODO:revisar
		//textField.text = Helper.Translate(options[currentOption].GetName());
	}
	
	override public function OnActionHandler():Void 
	{
		super.OnActionHandler();
		
		if (currentOption + 1 < options.length)
			currentOption++;
		else
			currentOption = 0;
			
		//TODO: revisar
		//textField.text = Helper.Translate(options[currentOption].GetName());
	}
}