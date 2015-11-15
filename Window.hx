package;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;


/**
 * ...
 * @author Henry D. Fernández B.
 */
class Window extends DraggableWindow
{
	/*
	 * Animation ended event.
	 * */
	static public var NAME : String = "WINDOW";
	
	var console : TextField;
	var consoleText : TextField;
	var inputs : Array<InputText>;
	
	public function new(x : Float,y : Float,width : Float,height : Float,eventDispatcher : EventDispatcher) 
	{
		super(x, y, width, height, 0x000000,eventDispatcher);
		
		inputs = new Array<InputText>();
		
		addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
	}

	public function GetInputs() : Array<InputText>
	{
		return inputs;
	}
	
	public function Update(gameTime : Float) : Void
	{
		for (i in inputs)
			i.Update(gameTime);
	}
	
	public function HandleKeyDownEvent(key:UInt)
	{
		for (i in inputs)
		{
			if (i.IsFocused())
				i.HandleKeyDownEvent(key);
		}
	}
	
	public function HandleKeyUpEvent(key:UInt)
	{
		for (i in inputs)
		{
			if (i.IsFocused())
				i.HandleKeyUpEvent(key);
		}
	}
	
	public function HandleMouseDown(mousePos : Point) : Void
	{
		trace(mousePos);
		for (i in inputs)
		{
			trace(new Point(x + i.x, y + i.y));
			trace(i.width);
			if (MathHelper.PointInsideRectangle(mousePos,new Point(x + i.x,y + i.y),i.width,i.height))
				i.Focus();
			else
				i.UnFocus();
		}
	}
	
	override private function OnClose(event:Event):Void 
	{
		Clean();
	}
	
	private function Clean() : Void
	{
		consoleText.text = "";
	}
	
	public function AddInputText(input : InputText) : Void
	{
		inputs.push(input);
		#if windows
		addChild(input);
		#end
	}
	
	private function OnMouseDown(event:MouseEvent):Void 
	{
		//super.OnMouseDown(event);
		for (i in inputs)
		{
			i.UnFocus();
		}
	}
	
	private function OnMouseUp(event:MouseEvent):Void 
	{
		//super.OnMouseDown(event);
		//trace("WIIIN DOWN");
	}
}