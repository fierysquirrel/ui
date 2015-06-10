package fs.ui;

import aze.display.TileLayer;
import aze.display.TileSprite;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class PagerButton extends Button
{	
	static public var NAME : String = "UIPager";
	static public var SELECTED_ALPHA : Float = 1;
	static public var SELECTED_SCALE : Float = 1;
	static public var DESELECTED_ALPHA : Float = 0.5;
	static public var DESELECTED_SCALE : Float = 0.8;
	
	private var number : Int;
	
	private var selected : Bool;
	
	/*
	 * An array for all positions, ID, frames
	 * This array is used to draw the animation.
	 * */
	private var imgData:Array<Float>;
	
	public function new(id : String,tileLayer : TileLayer,x : Float, y : Float,number : Int,selected : Bool,onPressHandlerName : String) 
	{
		super(NAME, id, tileLayer, x, y, onPressHandlerName, 0xffffff, 0xffffff, "pager");
		
		this.selected = selected;
		this.number = number;
		if (selected)
			SetScale(SELECTED_SCALE * Helper.GetFixScale());
		else
		{
			SetScale(DESELECTED_SCALE * Helper.GetFixScale());
			SetAlpha(DESELECTED_ALPHA);
		}
			
		activeSprite.r = 1;
		activeSprite.g = 1;
		activeSprite.b = 1;
	}
	
	/*function OnPressed(e : MouseEvent)
	{
		Helper.PlaySound(Globals.CLICK_BUTTON_SOUND);
		eventDispatcher.dispatchEvent(new GameScreenEvent(ScreenManager.EVENT_SCREEN_LOADED,new LevelSelectionScreen(eventDispatcher,Globals.SCREEN_WIDTH,Globals.SCREEN_HEIGHT,number)));
	}*/
	
	public function GetNumber() : Int
	{
		return number;
	}
	
	public function Select() : Void
	{
		SetScale(SELECTED_SCALE * Helper.GetFixScale());
		SetAlpha(SELECTED_ALPHA);
		
		selected = true;
	}
	
	public function DeSelect() : Void
	{
		SetScale(DESELECTED_SCALE * Helper.GetFixScale());
		SetAlpha(DESELECTED_ALPHA);
		
		selected = false;
	}
}