package fs.ui;

import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.events.MouseEvent;
import fs.helper.MathHelper;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Select extends UIObject
{
	static public var TYPE : String = "Select";

	private var activeColor : Int;
	private var pressColor : Int;
	private var activeSprite : TileSprite;
	private var pressSprite : TileSprite;
	private var options : Array<Option>;
	private var currentOption : Int;
	private var activeRGBColor : Array<Float> ;
	private var pressedRGBColor : Array<Float> ;
	
	public function new(name : String,id : String,tileLayer : TileLayer, x : Float,y : Float,onPressHandlerName : String,options : Array<Option>,currentOption : Int,activeColor : Int = 0xffffff,pressColor : Int = 0xffffff,activeSpriteName : String = "",pressSpriteName : String = "") 
	{
		super(TYPE,name,id,tileLayer,x, y,onPressHandlerName);
		
		this.activeColor = activeColor;
		this.pressColor = pressColor;
		activeRGBColor = MathHelper.HexToRGB(activeColor);
        pressedRGBColor = MathHelper.HexToRGB(pressColor);
		this.options = options;
		this.currentOption = currentOption;
		
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
	}
	
	public function ChangeCurrentOption(option : String) : Void
	{
		for (i in 0...options.length)
		{
			if (options[i].GetName() == option)
			{
				currentOption = i;
				break;
			}
		}
	}
	
	public function GetSelectedOption() : Option
	{
		return options[currentOption];
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
}