package;

import openfl.display.Tilemap;
import openfl.display.Tile;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class ImageCheckBox extends CheckBox
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "UIImageCheckbox";
	static public var XML : String = "imagecheckbox";
	
	private var checkSprite : Tile;
	private var uncheckSprite : Tile;
	
	public function new(id : String,tileLayer : Tilemap,x : Float,y : Float,onCheckedHandlerName : String,onUncheckedHandlerName : String, checked : Bool,activeColor : Int = 0xFFFFFF, pressColor : Int = 0xFFFFFF, activeSprite : String, pressSprite : String,checkSpriteName : String,uncheckSpriteName : String, actionEffect : UIObject.Effect = null,highlightEffect : UIObject.Effect = null) 
	{
		super(NAME, id, tileLayer, x, y, checked, onCheckedHandlerName, onUncheckedHandlerName, activeColor, pressColor, activeSprite, pressSprite,actionEffect,highlightEffect);
		
		checkSprite = new TileSprite(tileLayer, checkSpriteName);
		uncheckSprite = new TileSprite(tileLayer, uncheckSpriteName);
		if (checkSprite != null)
		{
			checkSprite.r = activeRGBColor[0];
			checkSprite.g = activeRGBColor[1];
			checkSprite.b = activeRGBColor[2];
			addChild(checkSprite);
			checkSprite.visible = checked;
			transform.addProxy(checkSprite);
		}
		
		if (uncheckSprite != null)
		{
			uncheckSprite.r = activeRGBColor[0];
			uncheckSprite.g = activeRGBColor[1];
			uncheckSprite.b = activeRGBColor[2];
			addChild(uncheckSprite);
			uncheckSprite.visible = !checked;
			transform.addProxy(uncheckSprite);
		}
	}
	
	override public function ChangeState(state : UIObject.State):Void 
	{
		switch(state)
		{
			case Active:
				if (checked)
				{
					checkSprite.r = activeRGBColor[0];
					checkSprite.g = activeRGBColor[1];
					checkSprite.b = activeRGBColor[2];
				}
				else
				{
					uncheckSprite.r = activeRGBColor[0];
					uncheckSprite.g = activeRGBColor[1];
					uncheckSprite.b = activeRGBColor[2];
				}
			case Pressed:
				if (checked)
				{
					checkSprite.r = pressedRGBColor[0];
					checkSprite.g = pressedRGBColor[1];
					checkSprite.b = pressedRGBColor[2];
				}
				else
				{
					uncheckSprite.r = pressedRGBColor[0];
					uncheckSprite.g = pressedRGBColor[1];
					uncheckSprite.b = pressedRGBColor[2];
				}
			default:
		}
		
		super.ChangeState(state);
	}
	
	override public function Check():Void 
	{
		super.Check();
		checkSprite.visible = true;
		uncheckSprite.visible = false;
	}
	
	override public function Uncheck():Void 
	{
		super.Uncheck();
		checkSprite.visible = false;
		uncheckSprite.visible = true;
	}
}