package;

import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class ImageButton extends Button
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "UIImageButton";
	static public var XML : String = "imagebutton";
	
	private var image : TileSprite;
	
	public function new(id : String,tileLayer : TileLayer,x : Float, y: Float, onPressHandlerName : String,activeColor : Int = 0xFFFFFF,pressColor : Int = 0xFFFFFF,activeSprite : String,pressSprite : String, imageSprite : String,flipX : Bool = false,onSoundHandlerName : String = "", imageOffset : Point = null, scale : Float = 1, actionEffect : UIObject.Effect = null,highlightEffect : UIObject.Effect = null) 
	{
		super(NAME, id, tileLayer, x, y, onPressHandlerName, activeColor, pressColor, activeSprite, pressSprite,onSoundHandlerName,actionEffect,highlightEffect);
		
		if (imageSprite != "")
		{
			image = new TileSprite(tileLayer, imageSprite);
			image.r = activeRGBColor[0];
			image.g = activeRGBColor[1];
			image.b = activeRGBColor[2];
			image.scale = scale;
			
			if (imageOffset != null)
			{
				image.x = imageOffset.x;
				image.y = imageOffset.y;
			}
			
			if(flipX)
				image.scaleX = -image.scaleX;
			addChild(image);
			transform.addProxy(image);
		}
	}
	
	override public function ChangeState(state : UIObject.State):Void 
	{
		
		if (state != this.state)
		{
			switch(state)
			{
				case Active:
					image.r = activeRGBColor[0];
					image.g = activeRGBColor[1];
					image.b = activeRGBColor[2];
				case Pressed:
					image.r = pressedRGBColor[0];
					image.g = pressedRGBColor[1];
					image.b = pressedRGBColor[2];
				default:
			}
		}
		
		super.ChangeState(state);
	}
	
	public function GetImage() : TileSprite
	{
		return image;
	}
}