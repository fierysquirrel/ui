package fs.ui;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.Lib;

/**
 * ...
 * @author Henry Fernández
 */

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		var b : UIObject;
		var w : Window;
		
		//b = new UIObject("", "", "", null, 0, 0, "");
		//b = new CheckBox("", "", null, 0, 0, false, "", "");
		//b = new ImageButton("", null, 0, 0, "",0,0,"","","",false);
		//b = new ImageCheckBox("", null, 0, 0, "", "", false, 0, 0, "", "", "", "");
		//b = new Select("", "", null, 0, 0, "", [], 0, 0, 0, "", "");
		//b = new Slider("", null, 0, 0, [], "", 0, false, 0, 0, false, 0, 0, 0) ;
		//b = new TextButton("", null, 0, 0, "","",null,0,0,0,"","",0);
		//b = new TextCheckBox("", null, 0, 0, "", "", false, "", "", null, 0, 0, 0, "", "", 0, true);
		//b = new TextSelect("", null, 0, 0, "", [], 0, null, 0, 0, 0, "", "", 0);
		
		w = new Window(0, 0, 100, 100, null);

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
