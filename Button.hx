package;

import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.geom.Point;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;


/**
 * ...
 * @author Henry D. Fernández B.
 */
class Button extends UIObject
{
	static public var TYPE : String = "Button";

	private var activeColor : Int;
	private var pressColor : Int;
	private var activeSprite : TileSprite;
	private var pressSprite : TileSprite;
	private var activeRGBColor : Array<Float> ;
	private var pressedRGBColor : Array<Float> ;

	private var downIds : Array<Int> ;

	private var downId : Int;
	
	public function new(name : String,id : String,tileLayer : TileLayer, x : Float,y : Float,onPressHandlerName : String = "",activeColor : Int = 0xffffff,pressColor : Int = 0xffffff,activeSpriteName : String = "",pressSpriteName : String = "",onSoundHandlerName : String = "", actionEffect : UIObject.Effect = null,highlightEffect : UIObject.Effect = null) 
	{
		super(TYPE,name,id,tileLayer,x, y,onPressHandlerName,onSoundHandlerName,actionEffect,highlightEffect);
		
		this.activeColor = activeColor;
		this.pressColor = pressColor;
		activeRGBColor = MathHelper.HexToRGB(activeColor);
        pressedRGBColor = MathHelper.HexToRGB(pressColor);

		downIds = new Array<Int>();

		if (activeSpriteName != "")
		{
			activeSprite = new TileSprite(tileLayer, activeSpriteName);
			activeSprite.r = 1;
			activeSprite.g = 1;
			activeSprite.b = 1;
			addChild(activeSprite);
			transform.addProxy(activeSprite);
		}
			
		if (pressSpriteName != "")
		{
			pressSprite = new TileSprite(tileLayer, pressSpriteName);
			pressSprite.r = 1;
			pressSprite.g = 1;
			pressSprite.b = 1;
			pressSprite.visible = false;
			addChild(pressSprite);
			transform.addProxy(pressSprite);
		}
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


	/*override public function HandleMouseDownEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool, cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isDown : Bool;
		var containsCursorId : Bool;

		pos = new Point(x, y);
		isDown = false;

		containsCursorId = CheckIfCursorExists(cursorId);

		if(!containsCursorId)
		{
			if (state == Active)
			{
				isDown = MathHelper.PointInsideRectangle(mousePos, pos, width, height);
				if(isDown)
				{
					ChangeState(Pressed);
					downIds.push(cursorId);
				}
			}
		}

		return isDown;
	}

	override public function HandleMouseUpEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool, cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isUp : Bool;
		var containsCursorId : Bool;

		pos = new Point(x, y);
		isUp = false;

		if (state == Pressed)
		{
			containsCursorId = CheckIfCursorExists(cursorId);

			if(containsCursorId)
			{
				isUp = MathHelper.PointInsideRectangle(mousePos, pos, width, height);
				downIds.remove(cursorId);
				if(downIds.length <= 0 && isUp)
				{
					ChangeState(Active);
					//We call the function that is defined in the inherited class and specified in the XML
					if (onActionHandlerName != "")
					{
						Helper.PlaySound(Globals.CLICK_UI_OBJECT_SOUND);
						OnActionHandler();
						Reflect.callMethod(caller, Reflect.field(caller, onActionHandlerName), [this]);
					}
				}
			}
		}

		return isUp;
	}

	override public function HandleMouseMoveEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool, cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isMove : Bool;
		var containsCursorId : Bool;

		pos = new Point(x, y);
		isMove = false;

		if (state == Pressed)
		{
			containsCursorId = CheckIfCursorExists(cursorId);
			if(containsCursorId)
			{
				isMove = Helper.PointOutsideRectangle(mousePos, pos, width, height);
				if (isMove)
				{
					downIds.remove(cursorId);
					if(downIds.length <= 0)
						ChangeState(Active);
				}
			}
		}

		return isMove;
	}

	private function CheckIfCursorExists(id : Int) : Bool
	{
		var containsCursorId : Bool;

		containsCursorId = false;
		for (d in downIds)
		{
			if (d == id)
			{
				containsCursorId = true;
				break;
			}
		}

		return containsCursorId;
	}*/
}