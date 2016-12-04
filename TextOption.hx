package;
import flash.geom.ColorTransform;


/**
 * ...
 * @author Henry D. Fernández B.
 */
class TextOption extends Option
{
	private var text : Text;
	private var font : String;
	
	public function new(name : String,value : String, font : String) 
	{
		super(name, value);
		this.font = font;
	}
	
	public function SetText(text : Text) : Void
	{
		this.text = text;
	}
	
	public function GetFont() : String
	{
		return font;
	}
	
	public function Show() : Void
	{
		text.visible = true;
	}
	
	public function ChangeTextColor(color : ColorTransform)
	{
		text.transform.colorTransform = color;
	}
	
	public function Hide() : Void
	{
		text.visible = false;
	}
}