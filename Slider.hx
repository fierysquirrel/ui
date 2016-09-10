package;

import aze.display.behaviours.TileGroupTransform;
import aze.display.TileGroup;
import aze.display.TileLayer;
import flash.geom.Point;
import flash.text.TextField;

enum Direction
{
	Left;
	Right;
	None;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Slider extends UIObject
{
	static public var NAME : String = "UISlider";
	static public var XML : String = "slider";
	
	private var center : Float;
	private var maxSpeed : Float;
	private var minSpeed : Float;
	private var maxLimit : Float;
	private var minLimit : Float;
	private var movingThreshold : Float;
	private var changedPos : Bool;
	private var lastMouseX : Float;
	private var dragPos : Float;
	private var initialPos : Float;
	private var finalPos : Float;
	private var isMoving : Bool;
	private var isDragging : Bool;
	private var isPressing : Bool;
	private var pages : Array<SliderPage>;
	private var direction : Direction;
	private var currentElement : Int;
	private var pagers : Array<PagerButton>;
	private var previousElement : Int;
	private var mousePos : Float;
	private var groupTrans : TileGroupTransform;
	private var speed : Float;
	private var currentPage: Int;
	private var hasPager : Bool;
	private var pagerX : Float;
	private var pagerY : Float;
	private var pagerSeparation : Float;
	private var pagersGroup : TileGroup;
	private var isSliding : Bool;
	private var downCursor : Int;
	private var title : SliderTitle;
	
	public function new(id : String,tileLayer : TileLayer, x : Float,y : Float,pages : Array<SliderPage>,onPressHandlerName : String = "",minLimit : Float,maxLimit : Float,minSpeed : Float,maxSpeed : Float,movingThreshold : Float,title : SliderTitle = null, initialPage : Int = 1,hasPager : Bool = false, pagerX : Float = 0,pagerY : Float = 0, pagerSeparation : Float = 0) 
	{
		super(NAME,NAME, id, tileLayer, x, y, onPressHandlerName);
		
		var pager : PagerButton;
		var auxX : Float;
	
		this.minLimit = minLimit;
		this.maxLimit = maxLimit;
		this.minSpeed = minSpeed;
		this.maxSpeed = maxSpeed;
		this.movingThreshold = movingThreshold;
		this.initialX = x;
		this.initialY = y;
		this.pages = pages;
		this.hasPager = hasPager;
		this.pagerX = pagerX;
		this.pagerY = pagerY;
		this.pagerSeparation = pagerSeparation;
		
		center = (maxLimit - minLimit) / 2;
		
		this.title = title;
		
		if (hasPager)
		{
			pagersGroup = new TileGroup(tileLayer);
			pagers = new Array<PagerButton>();
		}
	
		auxX = 0.0;
		for (p in pages)
		{
			addChild(p);
			p.SetSlider(this);
			if (hasPager)
			{
				pager = new PagerButton(Std.string(p.GetNumber()), tileLayer, auxX, pagerY, p.GetNumber(), initialPage == p.GetNumber(), "");
				//TODO: check this
				//pager.SetScale(Helper.GetFixScale());
				pagers.push(pager);
				pagersGroup.addChild(pager);
				
				auxX += pagerSeparation;
			}
		}
		
		if (hasPager)
		{
			pagersGroup.x += pagerX - (auxX - pagerSeparation)/2;
			tileLayer.addChild(pagersGroup);
		}
			
		groupTrans = new TileGroupTransform(this);
		
		speed = 0;
		currentPage = initialPage;
		direction = None;
		
		this.x = initialX - pages[currentPage].x;
		
		initialPos = this.x;
		
		if (title != null)
			title.LoadContent(tileLayer);
		
		downCursor = -1;
		
		title.ChangeText(pages[currentPage].GetTitle());
		UpdatePagers();
		
		//
		SetIsCurrentPage();
	}
	
	override public function SetScale(value:Float):Void 
	{
		super.SetScale(value);
		
		for (p in pagers)
			p.SetScale(value);
	}
	
	override public function LoadContent():Void 
	{
		super.LoadContent();
	
		for (p in pages)
			p.LoadContent();
		
		if (hasPager)
		{
			for (p in pagers)
				p.LoadContent();
		}
	}
	
	public function IsSliding() : Bool
	{
		return isSliding;
	}

	override public function Update(gameTime:Float):Void 
	{
		//super.Update(gameTime);

		switch(direction)
		{
			case Left:
				if (pages[currentPage].GetX() <= center)
				{
					speed = 0;
					x = initialX - pages[currentPage].x;
					direction = None;
					//Esto es para hacer el efecto del menu
					//pages[currentPage].DoCurrentEffect();
				}
				else
					speed = -(minSpeed + Math.abs((maxSpeed * ((center) - pages[currentPage].GetX())) / (center)));
					
			case Right:
				if (pages[currentPage].GetX() >= center)
				{
					speed = 0;
					x = initialX - pages[currentPage].x;
					direction = None;
					//Esto es para hacer el efecto del menu
					//pages[currentPage].DoCurrentEffect();
				}
				else
					speed = minSpeed + (Math.abs((maxSpeed * ((center) - pages[currentPage].GetX())) / (center)));
			case None:
		}
		
		x += speed;
		
		//Update
		for (p in pages)
			p.Update(gameTime);
			
		
		if(title != null)
			title.ChangeText(pages[currentPage].GetTitle());
	}
	
	public function UpdatePagers() : Void
	{
		if (hasPager)
		{
			for (i in 0...pagers.length)
			{
				if (i == currentPage)
					pagers[i].Select();
				else
					pagers[i].DeSelect();
			}
			
		}
	}
	
	public function GetElements() : Array<SliderPageButton>
	{
		var buttons : Array<SliderPageButton>;
		
		buttons = new Array<SliderPageButton>();
		
		for (p in pages)
		{
			for (e in p.GetElements())
				buttons.push(e);
		}
		return buttons;
	}
	
	public function SetPage(page :Int) : Void
	{
		this.currentPage = page;
		this.x = initialX - pages[currentPage].x;
		initialPos = this.x;
		title.ChangeText(pages[currentPage].GetTitle());
		SetIsCurrentPage();
		UpdatePagers();
	}
	
	public function SetIsCurrentPage() : Void
	{
		for (i in 0...pages.length)
			pages[i].SetIsCurrentElement(currentPage == i);
	}
	
	private function HandlePagerButtonPressed(pager : PagerButton) : Void
	{
	}

	override public function HandleMouseUpEvent(mousePos:Point, caller:Dynamic, isCursorDown:Bool, cursorId : Int = -1):Bool
	{
		var res : Bool = super.HandleMouseUpEvent(mousePos, caller, isCursorDown);
		var spd, finalPos : Float;

		if(downCursor == cursorId)
		{
			spd = minSpeed + Math.abs(((maxSpeed * pages[currentPage].GetX()) / (center)));

			//Center
			if (pages[currentPage].GetX() == center)
				pages[currentPage].HandleMouseUp(mousePos, caller, isCursorDown);
			//Right
			else if(pages[currentPage].GetX() > center)
			{
				//Touched
				if (Math.abs(dragPos - mousePos.x) <= movingThreshold)
					pages[currentPage].HandleMouseUp(mousePos,caller,isCursorDown);

				if (pages[currentPage].GetX() <= center + movingThreshold)
				{
					//TODO: check this
					speed = -spd;
					direction = Left;
				}
				else
				{
					if (currentPage - 1 >= 0)
					{
						if (pages[currentPage].GetX() >= maxLimit)
						{
							//TODO: check this
							speed = -spd;
							direction = Left;
						}
						else
						{
							//TODO: check this
							speed = spd;
							direction = Right;
						}

						currentPage--;
						SetIsCurrentPage();
						UpdatePagers();
					}
					else
					{
						//TODO: check this
						speed = -spd;
						direction = Left;
					}
				}
			}
			//Left
			else if(pages[currentPage].GetX() < center)
			{
				//Touched
				if (Math.abs(dragPos - mousePos.x) <= movingThreshold)
					pages[currentPage].HandleMouseUp(mousePos,caller,isCursorDown);

				if (pages[currentPage].GetX() >= (center) - movingThreshold)
				{
					//TODO: check this
					speed = spd;
					direction = Right;
				}
				else
				{
					if (currentPage + 1 < pages.length)
					{
						if (pages[currentPage].GetX() <= 0)
						{
							//TODO: check this
							speed = spd;
							direction = Right;
						}
						else
						{
							//TODO: check this
							speed = -spd;
							direction = Left;
						}

						currentPage++;
						SetIsCurrentPage();
						UpdatePagers();
					}
					else
					{
						//TODO: check this
						speed = spd;
						direction = Right;
					}
				}
			}

			downCursor = -1;
		}
		
		return true;
	}

	override public function HandleMouseMoveEvent(mousePos:Point, caller:Dynamic, isCursorDown:Bool, cursorId : Int = -1):Bool
	{
		var res : Bool = super.HandleMouseMoveEvent(mousePos, caller, isCursorDown);

		if(downCursor == cursorId)
		{
			x = initialPos - (dragPos - mousePos.x);
		
			pages[currentPage].HandleMouseMove(mousePos, caller, isCursorDown);
		}
		
		return false;
	}
	
	override public function HandleMouseDownEvent(mousePos:Point, caller:Dynamic, isCursorDown:Bool, cursorId : Int = -1):Bool
	{
		var res : Bool = super.HandleMouseDownEvent(mousePos, caller, isCursorDown);

		if(downCursor == -1)
		{
			dragPos = mousePos.x;
			initialPos = x;

			pages[currentPage].HandleMouseDown(mousePos,caller,isCursorDown);

			downCursor = cursorId;
		}
		
		return true;
	}

	public function GetSelection() : Int
	{
		//TODO: esto no está bien porque no es general, debería ser el elemento seleccionado dentro de la página
		return pages[currentPage].GetNumber();
	}
}