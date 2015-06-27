package fs.ui;

import aze.display.TileLayer;
import aze.display.TileSprite;


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
	private var sprite : TileSprite;
	
	public function new(id : String,tileLayer : TileLayer,x : Float,y : Float,spriteName : String,onPressHandlerName : String) 
	{
		super(TYPE,NAME, id, tileLayer, x, y, onPressHandlerName);
		
		this.spriteName = spriteName;
		this.sprite = new TileSprite(tileLayer, spriteName);
		addChild(sprite);
	}
}