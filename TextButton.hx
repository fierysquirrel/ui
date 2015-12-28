package;

import aze.display.TileLayer;
import flash.geom.Point;
import flash.geom.ColorTransform;
import flash.text.Font;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class TextButton extends Button
{	
	static public var NAME : String = "UITextButton";
	static public var XML : String = "textbutton";
	
	private var text : String;
	private var textField : Text;
	private var activeTxtColor : ColorTransform;
    private var pressTxtColor : ColorTransform;
	private var initialTextY : Float;
	
	public function new(id : String,tileLayer : TileLayer, x : Float,y : Float,onPressHandlerName : String,text : String = "",fontId : String = null,size : Int = 0,activeColor : Int = 0xFFFFFF,pressColor : Int = 0xFFFFFF,activeSprite : String,pressSprite : String, letterSpacing : Int = 0,onSoundHandlerName : String = "") 
	{
		super(NAME,id, tileLayer, x, y, onPressHandlerName,activeColor,pressColor,activeSprite,pressSprite,onSoundHandlerName);
		
		this.text = text;
        this.activeTxtColor = new ColorTransform(activeRGBColor[0],activeRGBColor[1],activeRGBColor[2]);
        this.pressTxtColor = new ColorTransform(pressedRGBColor[0], pressedRGBColor[1], pressedRGBColor[2]);
		
		if (text != "")
		{
			textField = TextManager.CreateText(fontId, text, new Point(x, y), size, activeColor, letterSpacing);
			tileLayer.view.addChild(textField);
		}
	}
	
	override public function ChangeState(state : UIObject.State):Void 
	{
		
		if (text != "" && state != this.state && textField != null)
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
	
	public function TranslateText() : Void
	{
		//TODO: Corregir esto
		//textField.text = Helper.Translate(text);
		//textField.x = x - textField.width / 2;
	}
	
	override public function SetScale(value:Float):Void 
	{
		super.SetScale(value);
		
		//textField.defaultTextFormat.size = Helper.FixIntScale2Screen(value);
		//textField.scaleX = value;
		//textField.scaleY = value;
	}
	
	override public function SetAlpha(value:Float):Void 
	{
		super.SetAlpha(value);
		
		textField.alpha = value;
	}
	
	override public function UpdateY(value :Float):Void 
	{
		super.UpdateY(value);
		
		textField.y += value;
	}
	
	override public function UpdateX(value :Float):Void 
	{
		super.UpdateX(value);
		
		textField.x += value;
	}
	
	override public function InitializeY():Void 
	{
		super.InitializeY();
		
		//textField.y = y + initialTextY - textField.height/2;
	}
}