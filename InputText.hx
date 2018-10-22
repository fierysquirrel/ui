package;

import flash.text.TextField;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;
import flash.events.MouseEvent;

/**
 * ...
 * @author Henry Fernández
 */
class InputText extends TextField
{
	private var shifPressed : Bool;
	private var isFocused : Bool;
	//private var object : GameObject;
	
	public function new(x : Float,y:Float,width:Float,height : Float)//,obj : GameObject) 
	{
		super();
		
		var format : TextFormat;
		var textField : TextField;
		
		format = new TextFormat ("Verdana",16,0x000000);
		//this.object = obj;
		this.defaultTextFormat = format;
		this.selectable = false;
		this.width = width;
		this.height = height;
		this.alpha = 0.5;
		//this.wordWrap = true;
		//status.multiline = true;
		this.backgroundColor = 0xffffff;
		this.background = true;
		this.border = true;
		this.borderColor = 0x000000;
		this.x = x;
		this.y = y;
		
		shifPressed = false;
		text = "";
		isFocused = false;
		
		addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
	}
	
	public function IsFocused() : Bool
	{
		return isFocused;
	}
	
	public function Update(gameTime : Float) : Void
	{
		
	}
	
	public function HandleKeyDownEvent(key : UInt) : Void
	{
		switch(key)
		{
			case Keyboard.SHIFT:
				shifPressed = true;
			case Keyboard.RIGHT:
			case Keyboard.LEFT:
			case Keyboard.UP:
			case Keyboard.DOWN:
			case Keyboard.ENTER:
				//Reflect.setField(object,"bounces",text);
			case Keyboard.BACKSPACE:
				text = text.substr(0, text.length - 1);
			default:
				
				text += shifPressed ? String.fromCharCode(key).toUpperCase() : String.fromCharCode(key).toLowerCase();
		}
	}
	
	public function HandleKeyUpEvent(key : UInt) : Void
	{
		switch(key)
		{
			case Keyboard.SHIFT:
				shifPressed = false;
			default:
		}
	}
	
	public function Focus() : Void
	{
		isFocused = true;
		borderColor = 0xff0000;
	}
	
	public function UnFocus() : Void
	{
		isFocused = false;
		borderColor = 0x000000;
	}
	
	function OnMouseDown(event : MouseEvent) : Void
	{
	}
	
	function OnMouseUp(event : MouseEvent) : Void
	{
		Focus();
	}
}