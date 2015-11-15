package;

import aze.display.behaviours.TileGroupTransform;
import aze.display.TileGroup;
import aze.display.TileLayer;
import flash.geom.Point;
import flash.text.TextField;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class SliderPage extends TileGroup
{	
	static public var NAME : String = "UISliderPager";
	static public var XML : String = "page";
	private var elements : Array<SliderPageButton>;
	private var number : Int;
	private var trans : TileGroupTransform;
	private var title : String;
	private var slider : Slider;
	
	public function new(number : Int,tileLayer : TileLayer, x : Float, y : Float, title : String = "") 
	{
		super(tileLayer);
		
		this.number = number;
		this.title = title;
		this.x = x;
		this.y = y;
		elements = new Array<SliderPageButton>();
		trans = new TileGroupTransform(this);
	}
	
	public function SetSlider(slider:Slider) :Void
	{
		this.slider = slider;
	}
	
	public function LoadContent() : Void
	{
		for (e in elements)
			e.LoadContent();
	}
	
	public function GetTitle() : String
	{
		return title;
	}
	
	public function GetNumber() : Int
	{
		return number;
	}
	
	public function AddElement(e : SliderPageButton) : Void
	{
		elements.push(e);
		addChild(e);
	}
	
	public function GetSlider() : Slider
	{
		return slider;
	}
	public function GetElements() : Array<SliderPageButton>
	{
		return elements;
	}
	
	public function GetX() : Float
	{
		var res : Float;
		
		if (this.parent == null)
			res = x;
		else
			res = parent.x + x;
			
		return res;
	}
	
	public function SetIsCurrentElement(value : Bool) : Void
	{
		for (e in elements)
			e.SetIsCurrentElement(value);
	}
	
	public function DoCurrentEffect() : Void
	{
		for (e in elements)
			e.DoCurrentEffect();
	}
	
	public function GetY() : Float
	{
		var res : Float;
		
		if (this.parent == null)
			res = y;
		else
			res = parent.y + y;
			
		return res;
	}
	
	public function HandleMouseMove(mousePos:Point, caller:Dynamic, isCursorDown:Bool) : Void
	{
		var isMove : Bool;
		
		for (m in elements)
		{
			if (m.GetState() == UIObject.State.Pressed)
			{
				isMove = MathHelper.PointOutsideRectangle(mousePos, new Point(GetX() + m.x, GetY() + m.y), m.width, m.height);
				if (isMove && !isCursorDown)
					m.ChangeState(UIObject.State.Active);
			}
		}
	}
	
	public function HandleMouseDown(mousePos:Point, caller:Dynamic, isCursorDown:Bool) : Void
	{
		var isDown : Bool;
		
		for (m in elements)
		{
			isDown = false;
			if (m.GetState() != UIObject.State.Disabled)
			{
				isDown = MathHelper.PointInsideRectangle(mousePos, new Point(GetX() + m.x, GetY() + m.y), m.width, m.height);
				
				if (isDown && !isCursorDown)
					m.ChangeState(Pressed);
			}
		}
	}
	
	public function HandleMouseUp(mousePos:Point, caller:Dynamic, isCursorDown:Bool) : Void
	{
		var isUp : Bool;
		
		for (m in elements)
		{
			isUp = false;
			if (m.GetState() == UIObject.State.Pressed)
			{
				isUp = MathHelper.PointInsideRectangle(mousePos, new Point(GetX() + m.x, GetY() + m.y), m.width, m.height);
				
				if (isUp && !isCursorDown)
				{
					m.ChangeState(UIObject.State.Active);
					
					//We call the function that is defined in the inherited class and specified in the XML
					if (m.GetActionHandlerName() != "")
					{
						//TODO: Change this, customize it
						//Helper.PlaySound(Globals.CLICK_UI_OBJECT_SOUND);
						m.OnActionHandler();
						Reflect.callMethod(caller, Reflect.field(caller, m.GetActionHandlerName()), [m]);
					}
				}
			}
		}
	}
	
	public function Update(gameTime : Float) : Void
	{
		for (e in elements)
			e.Update(gameTime);
	}
}