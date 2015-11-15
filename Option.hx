package;


/**
 * ...
 * @author Henry D. Fernández B.
 */
class Option
{
	private var name : String;
	private var value : String;
	
	public function new(name : String,value : String) 
	{
		this.name = name;
		this.value = value;
	}
	
	public function GetValue() : String
	{
		return value;
	}
	
	public function GetName() : String
	{
		return name;
	}
}