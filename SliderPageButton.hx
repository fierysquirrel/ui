package;

import openfl.display.Tilemap;
import openfl.display.Tile;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class SliderPageButton extends UIObject
{	
	static public var LOCKED_ALPHA : Float = 0.9;

	private var number : Int;
	private var locked : Bool;
	private var backSprite : Tile;
	private var lockSprite : Tile;
	private var isCurrentElement : Bool;
	private var currentElementEffect : Bool;
	private var frameSprite : TileSprite;
	
	/*
	 * An array for all positions, ID, frames
	 * This array is used to draw the animation.
	 * */
	private var imgData:Array<Float>;
	
	public function new(name : String,id : String,tileLayer : Tilemap, back : String,frame : String,x : Float, y : Float,number : Int, locked : Bool,lockName : String,onPressHandlerName : String) 
	{
		super(Button.TYPE,name, id, tileLayer, x, y, onPressHandlerName);
		
		this.locked = locked;
		this.number = number;
		
		if (back != "")
		{
			backSprite = new Tile(tileLayer, back);
			addChild(backSprite);
			transform.addProxy(backSprite);
		}

		if (backSprite != null)
		{
			backSprite.r = 1;
			backSprite.g = 1;
			backSprite.b = 1;
		}
		
		isCurrentElement = false;
		currentElementEffect = false;
	}
	
	public function SetIsCurrentElement(value : Bool) : Void
	{
		this.isCurrentElement = value;
	}
	
	public function DoCurrentEffect() : Void
	{
		currentElementEffect = true;
	}
	
	public function IsLocked() : Bool
	{
		return locked;
	}
	
	public function GetNumber() : Int
	{
		return number;
	}
	
	override public function SetAlpha(value:Float):Void 
	{
		super.SetAlpha(value);
		
		if(backSprite != null && locked)
			backSprite.alpha = LOCKED_ALPHA;
	}
}