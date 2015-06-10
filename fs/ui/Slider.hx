package fs.ui;

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
	static public var MIN_SPEED : Float;
	static public var MOVING_THRESHOLD : Float;
	static public var TITLE_SIZE : Int;
	
	private var maxSpeed : Float;
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
	private var backTitle : TextField;
	private var title : TextField;
	private var hasTitle : Bool;
	private var hasPager : Bool;
	private var titleX : Float;
	private var titleY : Float;
	private var pagerX : Float;
	private var pagerY : Float;
	private var pagerSeparation : Float;
	private var pagersGroup : TileGroup;
	private var isSliding : Bool;
	private var downCursor : Int;
	
	public function new(id : String,tileLayer : TileLayer, x : Float,y : Float,pages : Array<SliderPage>,onPressHandlerName : String = "", initialPage : Int = 1, hasTitle : Bool = false, titleX : Float = 0,titleY : Float = 0,hasPager : Bool = false, pagerX : Float = 0,pagerY : Float = 0, pagerSeparation : Float = 0) 
	{
		super(NAME,NAME, id, tileLayer, x, y, onPressHandlerName);
		
		var pager : PagerButton;
		var auxX : Float;
		
		TITLE_SIZE = Helper.FixIntScale2Screen(50);
		
		this.initialX = x;
		this.initialY = y;
		this.hasTitle = hasTitle;
		this.titleX = titleX;
		this.titleY = titleY;
		this.pages = pages;
		this.hasPager = hasPager;
		this.pagerX = pagerX;
		this.pagerY = pagerY;
		this.pagerSeparation = pagerSeparation;
		
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
				pager.SetScale(Helper.GetFixScale());
				pagers.push(pager);
				pagersGroup.addChild(pager);
				
				auxX += pagerSeparation;
			}
		}
		
		pagersGroup.x += pagerX - (auxX - pagerSeparation)/2;
		tileLayer.addChild(pagersGroup);
			
		groupTrans = new TileGroupTransform(this);
		
		speed = 0;
		currentPage = initialPage;
		direction = None;
		
		MIN_SPEED = Helper.FixFloat2ScreenX(1);
		MOVING_THRESHOLD = Helper.FixFloat2ScreenX(80);
		maxSpeed = Helper.FixFloat2ScreenX(50);
		
		this.x = initialX - pages[currentPage].x;
		
		initialPos = this.x;
		
		if (hasTitle)
		{
			title = Helper.CreateText(Globals.HAND_OF_SEAN_FONT.fontName, "", TITLE_SIZE, 0xffffff, 3,new Point(titleX,titleY));
			backTitle = Helper.CreateText(Globals.HAND_OF_SEAN_FONT.fontName, "", TITLE_SIZE, 0x141d4c, 3,new Point(titleX,titleY));
			tileLayer.view.addChild(backTitle);
			tileLayer.view.addChild(title);
		}

		downCursor = -1;
		
		//
		SetIsCurrentPage();
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
	
	private function UpdateTitle() : Void
	{
		if (hasTitle)
		{
			title.text = pages[currentPage].GetTitle();
			title.x = titleX - title.width/2;
			title.y = titleY  - title.height / 2;
			
			backTitle.text = pages[currentPage].GetTitle();
			backTitle.x = titleX - title.width/2 - Helper.FixFloat2ScreenX(3);
			backTitle.y = titleY  - title.height/2  - Helper.FixFloat2ScreenY(3);
		}
		
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
		
		//Mejorar esto
		SetIsCurrentPage();
	}

	override public function Update(gameTime:Float):Void 
	{
		//super.Update(gameTime);

		switch(direction)
		{
			case Left:
				if (pages[currentPage].GetX() <= Globals.SCREEN_WIDTH/2)
				{
					speed = 0;
					x = initialX - pages[currentPage].x;
					direction = None;
					//Esto es para hacer el efecto del menu
					//pages[currentPage].DoCurrentEffect();
				}
				else
					speed = -(MIN_SPEED + Math.abs((maxSpeed * ((Globals.SCREEN_WIDTH/2) - pages[currentPage].GetX())) / (Globals.SCREEN_WIDTH / 2)));
					
			case Right:
				if (pages[currentPage].GetX() >= Globals.SCREEN_WIDTH/2)
				{
					speed = 0;
					x = initialX - pages[currentPage].x;
					direction = None;
					//Esto es para hacer el efecto del menu
					//pages[currentPage].DoCurrentEffect();
				}
				else
					speed = MIN_SPEED + (Math.abs((maxSpeed * ((Globals.SCREEN_WIDTH/2) - pages[currentPage].GetX())) / (Globals.SCREEN_WIDTH /2)));
			case None:
		}
		
		x += speed;
		
		//Update
		for (p in pages)
			p.Update(gameTime);
	}
	
	public function GetElements() : Array<Button>
	{
		var buttons : Array<Button>;
		
		buttons = new Array<Button>();
		
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
		SetIsCurrentPage();
		UpdateTitle();
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
			spd = MIN_SPEED + Math.abs(((maxSpeed * pages[currentPage].GetX()) / (Globals.SCREEN_WIDTH / 2)));

			//Center
			if (pages[currentPage].GetX() == Globals.SCREEN_WIDTH / 2)
				pages[currentPage].HandleMouseUp(mousePos, caller, isCursorDown);
			//Right
			else if(pages[currentPage].GetX() > Globals.SCREEN_WIDTH / 2)
			{
				//Touched
				if (Math.abs(dragPos - mousePos.x) <= MOVING_THRESHOLD/8)
					pages[currentPage].HandleMouseUp(mousePos,caller,isCursorDown);

				if (pages[currentPage].GetX() <= (Globals.SCREEN_WIDTH / 2) + MOVING_THRESHOLD)
				{
					speed = Helper.FixFloat2ScreenX(-spd);
					direction = Left;
				}
				else
				{
					if (currentPage - 1 >= 0)
					{
						if (pages[currentPage].GetX() >= Globals.SCREEN_WIDTH)
						{
							speed = Helper.FixFloat2ScreenX(-spd);
							direction = Left;
						}
						else
						{
							speed = Helper.FixFloat2ScreenX(spd);
							direction = Right;
						}

						currentPage--;
						UpdateTitle();
					}
					else
					{
						speed = Helper.FixFloat2ScreenX(-spd);
						direction = Left;
					}
				}
			}
			//Left
			else if(pages[currentPage].GetX() < Globals.SCREEN_WIDTH / 2)
			{
				//Touched
				if (Math.abs(dragPos - mousePos.x) <= MOVING_THRESHOLD/8)
					pages[currentPage].HandleMouseUp(mousePos,caller,isCursorDown);

				if (pages[currentPage].GetX() >= (Globals.SCREEN_WIDTH / 2) - MOVING_THRESHOLD)
				{
					speed = Helper.FixFloat2ScreenX(spd);
					direction = Right;
				}
				else
				{
					if (currentPage + 1 < pages.length)
					{
						if (pages[currentPage].GetX() <= 0)
						{
							speed = Helper.FixFloat2ScreenX(spd);
							direction = Right;
						}
						else
						{
							speed = Helper.FixFloat2ScreenX(-spd);
							direction = Left;
						}

						currentPage++;
						UpdateTitle();
					}
					else
					{
						speed = Helper.FixFloat2ScreenX(spd);
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