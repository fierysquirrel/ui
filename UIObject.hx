package;

import openfl.display.TileContainer;
import openfl.display.Tilemap;
import flash.events.EventDispatcher;
import flash.geom.Point;

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
	Push;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class UIObject extends TileContainer
{
	static public var EVENT_ACTION : String = "UIEventAction";

	private var type : String;

	private var name : String;
	
	private var objID : String;
	
	private var state : State;
	
	private var eventDispatcher : EventDispatcher;
	
	private var onActionHandlerName : String;
	
	private var onSoundHandlerName : String;
	
	//private var transform : TileGroupTransform;
	
	private var scale : Float;
	
	private var actionEffect : Effect;
	
	private var highlightEffect : Effect;
	
	private var effectWaitTime : Float;
	
	private var effectTime : Float;
	
	private var zoomingIn : Bool;
	
	private var initialX : Float;
	
	private var initialY : Float;
	
	private var initialScale : Float;
	
	public function new(type : String,name : String,id : String, tileLayer : Tilemap, x : Float, y : Float,onActionHandlerName : String, onSoundHandlerName : String = "", actionEffect : Effect = null, highlightEffect : Effect = null)
	{
		super();

		this.type = type;
		this.name = name;
		this.objID = id;
		this.x = x;
		this.y = y;
		this.initialX = x;
		this.initialY = y;
		this.onActionHandlerName = onActionHandlerName;
		this.onSoundHandlerName = onSoundHandlerName;
		this.scale = __scaleX; //could be __scaleY
		//transform = new TileGroupTransform(this);
		state = Active;
		this.highlightEffect = highlightEffect == null ? None : highlightEffect;
		this.actionEffect = actionEffect == null ? None : actionEffect;
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
	
	public function SetActionEffect(effect : Effect) : Void
	{
		this.actionEffect = effect;
	}
	
	public function SetHighlightEffect(effect : Effect) : Void
	{
		this.highlightEffect = effect;
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
		return objID;
	}
	
	public function ChangeState(state : State) : Void 
	{
		this.state = state;
	}
	
	public function Clean() : Void
	{
		while (numTiles > 0)
			removeTileAt(0);
	}
	
	public function GetScale() : Float
	{
		return scale;
	}
	
	public function SetScale(value : Float) : Void
	{
		//if (transform != null)
		//{
			if (initialScale == 0)
				initialScale = value;
				
			scale = value;
			__scaleX = scale;
			__scaleY = scale;
			//transform.update();
		//}
	}
	
	public function SetAlpha(value : Float) : Void
	{
		//if (transform != null)
		//{
			alpha = value;
			//transform.update();
		//}
	}
	
	public function SetVisibility(visibility : Bool) : Void
	{
		visible = visibility;
	}
	
	public function Enable() : Void
	{
		state = State.Active;
	}
	
	public function Disable() : Void
	{
		state = State.Disabled;
	}
	
	public function LoadContent() : Void
	{}
	
	public function Update(gameTime : Float) : Void
	{
	
		switch(highlightEffect)
		{
			//TODO: Generalizar esto en clases
			case Zoom:
				
				if (zoomingIn)
				{
					if (scale > GraphicManager.GetFixScale() * 0.9)
					{
						scale -= GraphicManager.GetFixScale() * 0.005;
					}
					else
					{
						scale = GraphicManager.GetFixScale() * 0.9;
						zoomingIn = false;
					}
				}
				else
				{
					if (scale < GraphicManager.GetFixScale())
					{
						scale += GraphicManager.GetFixScale() * 0.005;
					}
					else
					{
						scale = GraphicManager.GetFixScale();
						zoomingIn = true;
					}
				}
				
				//transform.update();
				
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
			isDown = MathHelper.PointInsideRectangle(mousePos, pos, rect.width, rect.height);
			if (isDown && !isCursorDown)
			{
				//Effect
				if (actionEffect == UIObject.Effect.Push)
				{
					//TODO: we have to make this a general behavior
					if(initialScale != 0)
						SetScale(initialScale * 0.95);
				}
						
				ChangeState(Pressed);
			}
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
			isUp = MathHelper.PointInsideRectangle(mousePos, pos, rect.width, rect.height);
			if (!isCursorDown)
			{
				//Effect
				if (actionEffect == UIObject.Effect.Push)
				{
					//TODO: we have to make this a general behavior
					if (initialScale != 0)
						SetScale(initialScale);
				}
				
				ChangeState(Active);
				//If the object has any sound attatched to it
				if (onSoundHandlerName != "")
				{
					try
					{
						Reflect.callMethod(caller, Reflect.field(caller, onSoundHandlerName), [this]);
					}
					catch (e : String)
					{
						trace(e);
					}
				}
				
				//We call the function that is defined in the inherited class and specified in the XML
				if (onActionHandlerName != "")
				{
					try
					{
						OnActionHandler();
						Reflect.callMethod(caller, Reflect.field(caller, onActionHandlerName), [this]);
					}
					catch (e : String)
					{
						trace(e);
					}
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
			isMove = MathHelper.PointOutsideRectangle(mousePos, pos,rect.width, rect.height);
			if (isMove && !isCursorDown)
			{
				//Effect
				if (actionEffect == UIObject.Effect.Push)
				{
					//TODO: we have to make this a general behavior
					if(initialScale != 0)
						SetScale(initialScale);
				}
				ChangeState(Active);
			}
		}
		
		return isMove;
	}
	
	public function HandleKeyDownEvent(key : UInt) : Void
	{
	}
	
	public function HandleKeyUpEvent(key : UInt) : Void
	{
	}
	
	public function OnActionHandler() : Void
	{}
}