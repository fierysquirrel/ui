package;

import aze.display.TileLayer;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.text.Font;
import flash.text.TextField;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class TextCheckBox extends CheckBox
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "UITextCheckbox";
	static public var XML : String = "textcheckbox";
	
	private var checkedText : String;
	private var uncheckedText : String;
	private var activeTxtColor : ColorTransform;
    private var pressTxtColor : ColorTransform;
	private var textField : TextField;
	private var translate : Bool;
	
	public function new(id : String, tileLayer : TileLayer, x : Float, y : Float, onCheckedHandlerName : String, onUncheckedHandlerName : String, checked : Bool, checkedText : String = "", uncheckedText : String = "", font : Font = null, size : Int = 0, activeColor : Int = 0xFFFFFF, pressColor : Int = 0xFFFFFF, activeSprite : String, pressSprite : String, letterSpacing : Int = 0, translate : Bool = true) 
	{
		super(NAME, id, tileLayer, x, y,checked,onCheckedHandlerName,onUncheckedHandlerName,activeColor,pressColor,activeSprite,pressSprite);
		
		var txt : String;
		this.checkedText = checkedText;
		this.uncheckedText = uncheckedText;
		this.translate = translate;
		
        this.activeTxtColor = new ColorTransform(activeRGBColor[0],activeRGBColor[1],activeRGBColor[2]);
        this.pressTxtColor = new ColorTransform(pressedRGBColor[0], pressedRGBColor[1], pressedRGBColor[2]);
		
		if (checked)
		{
			if (checkedText != "")
			{
				//TODO: revisar esto
				//txt = translate ? Helper.Translate(checkedText) : checkedText;
				//textField = Helper.CreateText(font.fontName, txt, size, activeColor, letterSpacing, new Point(x, y));
			}
		}
		else
		{
			if (uncheckedText != "")
			{
				//TODO: revisar esto
				//txt = translate ? Helper.Translate(uncheckedText) : uncheckedText;
				//textField = Helper.CreateText(font.fontName, txt, size, activeColor, letterSpacing, new Point(x, y));
			}
		}
		
		if (textField != null)
			tileLayer.view.addChild(textField);
	}
	
	override public function ChangeState(state : UIObject.State):Void 
	{
		
		switch(state)
		{
			case Active:
				textField.transform.colorTransform = activeTxtColor;
			case Pressed:
				textField.transform.colorTransform = pressTxtColor;
			default:
		}
		
		super.ChangeState(state);
	}
	
	override public function Check():Void 
	{
		super.Check();
		var txt : String;
		//TODO: revisar esto
		/*txt = translate ? Helper.Translate(checkedText) : checkedText;
		textField.text = txt;
		textField.x = x - textField.width / 2;*/
	}
	
	override public function Uncheck():Void 
	{
		super.Uncheck();
		var txt : String;
		//TODO: revisar esto
		/*txt = translate ? Helper.Translate(uncheckedText) : uncheckedText;
		textField.text = txt;
		textField.x = x - textField.width / 2;*/
	}
	
	public function TranslateText() : Void
	{
		var txt : String;
		
		//TODO: revisar esto
		/*if (checked)
		{
			txt = translate ? Helper.Translate(checkedText) : checkedText;
			textField.text = Helper.Translate(checkedText);
		}
		else
		{
			txt = translate ? Helper.Translate(uncheckedText) : uncheckedText;
			textField.text = Helper.Translate(uncheckedText);
		}*/
			
		textField.x = x - textField.width / 2;
	}
}