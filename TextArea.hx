package;

import flash.text.TextField;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextFormat;
import flash.events.MouseEvent;
import openfl.display.Tilemap;

/**
 * ...
 * @author Henry Fernández
 */
class TextArea extends UIObject
{
	static public var TYPE : String = "UITextArea";
	static public var NAME : String = "UITextArea";
	static public var XML : String = "textarea";
	
	private var shifPressed : Bool;
	private var isFocused : Bool;
	private var textField : TextField;
	
	public function new(id : String,tileLayer : Tilemap,x : Float,y:Float,width:Float,height : Float)
	{
		super(TYPE,NAME,id,tileLayer,x, y,"");
		
		textField = new TextField();
		
		var format : TextFormat;
		
		format = new TextFormat ("Verdana",16,0x000000);
		//this.object = obj;
		textField.defaultTextFormat = format;
		textField.selectable = false;
		textField.width = width;
		textField.height = height;
		textField.alpha = 0.5;
		//this.wordWrap = true;
		//status.multiline = true;
		textField.backgroundColor = 0xffffff;
		textField.background = true;
		textField.border = true;
		textField.borderColor = 0x000000;
		textField.x = x;
		textField.y = y;
		
		shifPressed = false;
		textField.text = "";
		isFocused = false;
		
		tileLayer.view.addChild(textField);
		//addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
		//addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
	}
	
	public function IsFocused() : Bool
	{
		return isFocused;
	}
	
	public override function HandleKeyDownEvent(key : UInt) : Void
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
				textField.text = textField.text.substr(0, textField.text.length - 1);
			default:
				
				textField.text += shifPressed ? String.fromCharCode(key).toUpperCase() : String.fromCharCode(key).toLowerCase();
		}
	}
	
	public override function HandleKeyUpEvent(key : UInt) : Void
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
		textField.borderColor = 0xff0000;
	}
	
	public function UnFocus() : Void
	{
		isFocused = false;
		textField.borderColor = 0x000000;
	}
	
	function OnMouseDown(event : MouseEvent) : Void
	{
	}
	
	function OnMouseUp(event : MouseEvent) : Void
	{
		Focus();
	}
}