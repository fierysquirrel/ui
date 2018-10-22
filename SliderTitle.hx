package;

import flash.geom.Point;
import openfl.display.Tilemap;

/**
 * ...
 * @author Fiery Squirrel
 */
class SliderTitle extends Text
{
	public var backText : Text;
	private var backIniPos : Point;
	
	
	public function new(fontName:String, size:Int, color:Int,backColor:Int,backSep : Int, letterSpacing:Int, pos:Point=null, xAlign:String="center", yAlign:String="middle", bold:Bool, order:Int=0) 
	{
		super(fontName, "", size, color, letterSpacing, pos, xAlign, yAlign, bold, order);
		
		backIniPos = new Point(pos.x + backSep, pos.y + backSep);
		backText = new Text(fontName, "", size, backColor, letterSpacing, backIniPos, xAlign, yAlign, bold, order);
		//parent.addChild(backText);
	}
	
	public function LoadContent(tilelayer : Tilemap) : Void
	{
		tilelayer.view.addChild(backText);
		tilelayer.view.addChild(this);
	}
	
	public function ChangeText(title : String) : Void
	{
		text = title;
		x = initialPos.x - width / 2;
		y = initialPos.y - height / 2;
		
		backText.text = title;
		backText.x = backIniPos.x - backText.width / 2;
		backText.y = backIniPos.y - backText.height / 2;
	}
}