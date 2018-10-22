package;

import openfl.display.Tilemap;
import openfl.display.Tile;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class SliderElement extends UIObject
{
	static public var TYPE : String = "SliderElement";
	
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "UISliderElement";
	static public var XML : String = "element";
	
	private var spriteName : String;
	private var sprite : Tile;
	
	public function new(id : String,tileLayer : Tilemap,x : Float,y : Float,spriteName : String,onPressHandlerName : String) 
	{
		super(TYPE,NAME, id, tileLayer, x, y, onPressHandlerName);
		
		this.spriteName = spriteName;
		this.sprite = new Tile(tileLayer, spriteName);
		addChild(sprite);
	}
}