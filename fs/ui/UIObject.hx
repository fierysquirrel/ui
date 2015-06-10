package fs.ui;

import aze.display.behaviours.TileGroupTransform;
import aze.display.TileGroup;
import aze.display.TileLayer;
import flash.events.EventDispatcher;
import flash.geom.Point;
import fs.helper.MathHelper;

enum State
{
	Active;
	Pressed;
	Disabled;
}

enum Effect
{
	None;
	Zoom;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class UIObject extends TileGroup
{
	static public var EVENT_ACTION : String = "UIEventAction";

	private var type : String;

	private var name : String;
	
	private var id : String;
	
	private var state : State;
	
	private var eventDispatcher : EventDispatcher;
	
	private var onActionHandlerName : String;
	
	private var transform : TileGroupTransform;
	
	private var effect : Effect;
	
	private var effectWaitTime : Float;
	
	private var effectTime : Float;
	
	private var zoomingIn : Bool;
	
	private var initialX : Float;
	private var initialY : Float;
	
	public function new(type : String,name : String,id : String, tileLayer : TileLayer, x : Float, y : Float,onActionHandlerName : String)
	{
		super(tileLayer);

		this.type = type;
		this.name = name;
		this.id = id;
		this.x = x;
		this.y = y;
		this.initialX = x;
		this.initialY = y;
		this.onActionHandlerName = onActionHandlerName;
		//eventDispatcher = ScreenManager.EVENT_DISPATCHER;
		transform = new TileGroupTransform(this);
		state = Active;
		effect = None;
		effectTime = 0;
		zoomingIn = true;
	}
	
	public function GetInitialX() : Float
	{
		return initialX;
	}
	
	public function GetInitialY() : Float
	{
		return initialY;
	}
	
	public function UpdateY(value : Float) : Void
	{
		this.y += value;
	}
	
	public function UpdateX(value : Float) : Void
	{
		this.x += value;
	}
	
	public function InitializeY() : Void
	{
		this.y = initialY;
	}
	
	public function SetEffect(effect : Effect) : Void
	{
		this.effect = effect;
	}
	
	public function GetName() : String
	{
		return name;
	}

	public function GetType() : String
	{
		return type;
	}
	
	public function GetState() : State
	{
		return state;
	}
	
	public function GetActionHandlerName() : String
	{
		return onActionHandlerName;
	}
	
	public function GetId() : String
	{
		return id;
	}
	
	public function ChangeState(state : State) : Void 
	{
		this.state = state;
	}
	
	public function Clean() : Void
	{
		while (children.length > 0)
			removeChildAt(0);
	}
	
	public function SetScale(value : Float) : Void
	{
		if (transform != null)
		{
			transform.scale = value;
			transform.update();
		}
	}
	
	public function SetAlpha(value : Float) : Void
	{
		if (transform != null)
		{
			transform.alpha = value;
			transform.update();
		}
	}
	
	public function LoadContent() : Void
	{}
	
	public function Update(gameTime : Float) : Void
	{
		switch(effect)
		{
			case Zoom:
				//TODO: change the structure of this
				/*if (zoomingIn)
				{
					if (transform.scale > Helper.GetFixScale() * 0.95)
					{
						transform.scale -= Helper.GetFixScale() * 0.005;
					}
					else
					{
						transform.scale = Helper.GetFixScale() * 0.95;
						zoomingIn = false;
					}
				}
				else
				{
					if (transform.scale < Helper.GetFixScale())
					{
						transform.scale += Helper.GetFixScale() * 0.005;
					}
					else
					{
						transform.scale = Helper.GetFixScale();
						zoomingIn = true;
					}
				}
				
				transform.update();*/
				
			default:
		}
	}
	
	public function HandleMouseDownEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool, cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isDown : Bool;
		
		pos = new Point(x, y);
		isDown = false;
		
		if (state != Disabled)
		{
			isDown = MathHelper.PointInsideRectangle(mousePos, pos, width, height);
			if (isDown && !isCursorDown)
				ChangeState(Pressed);
		}
		
		return isDown;
	}
	
	public function HandleMouseUpEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool,cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isUp : Bool;
		
		pos = new Point(x, y);
		isUp = false;
		
		if (state == Pressed)
		{
			isUp = MathHelper.PointInsideRectangle(mousePos, pos, width, height);
			if (!isCursorDown)
			{
				ChangeState(Active);
				//We call the function that is defined in the inherited class and specified in the XML
				if (onActionHandlerName != "")
				{
					OnActionHandler();
					Reflect.callMethod(caller, Reflect.field(caller, onActionHandlerName), [this]);
				}
			}
		}
		
		return isUp;
	}
	
	public function HandleMouseMoveEvent(mousePos : Point, caller : Dynamic, isCursorDown : Bool, cursorId : Int = -1) : Bool
	{
		var pos : Point;
		var isMove : Bool;
		
		pos = new Point(x, y);
		isMove = false;
		
		if (state == Pressed)
		{
			isMove = MathHelper.PointOutsideRectangle(mousePos, pos, width, height);
			if (isMove && !isCursorDown)
				ChangeState(Active);
		}
		
		return isMove;
	}
	
	public function OnActionHandler() : Void
	{}
}