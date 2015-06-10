package fs.ui;

import aze.display.TileLayer;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import aze.display.TileSprite;
import fs.helper.MathHelper;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class CheckBox extends UIObject
{
	static public var TYPE : String = "Checkbox";

	private var checked : Bool;
	private var activeColor : Int;
	private var pressColor : Int;
	private var activeSprite : TileSprite;
	private var pressSprite : TileSprite;
	private var onCheckedHandlerName : String;
	private var onUncheckedHandlerName : String;
	private var activeRGBColor : Array<Float> ;
	private var pressedRGBColor : Array<Float> ;
	
	public function new(name : String,id : String,tileLayer : TileLayer,x : Float,y : Float,checked : Bool,onCheckedHandlerName : String,onUncheckedHandlerName : String, activeColor : Int = 0xffffff, pressColor : Int = 0xffffff, activeSpriteName : String = "", pressSpriteName : String = "") 
	{
		super(TYPE,name, id, tileLayer, x, y, "");
		
		this.checked = checked;
		this.activeColor = activeColor;
		this.pressColor = pressColor;
		activeRGBColor = MathHelper.HexToRGB(activeColor);
        pressedRGBColor = MathHelper.HexToRGB(pressColor);
		this.onCheckedHandlerName = onCheckedHandlerName;
		this.onUncheckedHandlerName = onUncheckedHandlerName;
		
		if(activeSpriteName != "")
			activeSprite = new TileSprite(tileLayer, activeSpriteName);
			
		if(pressSpriteName != "")
			pressSprite = new TileSprite(tileLayer, pressSpriteName);
		
		if (activeSprite != null)
		{
			activeSprite.r = activeRGBColor[0];
			activeSprite.g = activeRGBColor[1];
			activeSprite.b = activeRGBColor[2];
			addChild(activeSprite);
			transform.addProxy(activeSprite);
		}
			
		if (pressSprite != null)
		{
			pressSprite.r = activeRGBColor[0];
			pressSprite.g = activeRGBColor[1];
			pressSprite.b = activeRGBColor[2];
			pressSprite.visible = false;
			addChild(pressSprite);
			transform.addProxy(pressSprite);
		}
		
		if (checked)
			onActionHandlerName = onCheckedHandlerName;
		else
			onActionHandlerName = onUncheckedHandlerName;
	}
	
	override public function ChangeState(state : UIObject.State) : Void 
	{
		super.ChangeState(state);
		
		switch(state)
		{
			case Active:
				if(activeSprite != null)
					activeSprite.visible = true;
				if(pressSprite != null)
					pressSprite.visible = false;
			case Pressed:
				if(pressSprite != null)
					pressSprite.visible = true;
				if(activeSprite != null)
					activeSprite.visible = false;
			default:
		}
	}
	
	public function IsChecked() : Bool
	{
		return checked;
	}
	
	public function Check() : Void
	{
		onActionHandlerName = onCheckedHandlerName;
		checked = true;
	}
	
	public function Uncheck() : Void
	{
		onActionHandlerName = onUncheckedHandlerName;
		checked = false;
	}
	
	override public function OnActionHandler():Void 
	{
		super.OnActionHandler();
		
		if (checked)
			Uncheck();
		else
			Check();
	}
}