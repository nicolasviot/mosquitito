
use core
use base
use display
use gui
import Map.widgets.Menu


_define_
Drone(Process frame, double _x, double _y, double _rotation){
	Translation _t(_x, _y)

	Double width(92)
	Double height(78)
	Double cx (0)
	Double cy (0)
	Rotation _r(_rotation, 0, 0)
	NoFill _
	Rectangle bg(0, 0, 92, 78)
	Spike toogleShadow
	Spike untoogleShadow
	Double shadow (1)
	x aka _t.tx
	y aka _t.ty
	rot aka _r.a
	x + width / 2 =:> cx
	y + height / 2 =:> cy
	width / 2 =:> _r.cx
    height / 2 =:> _r.cy
	svgdrone  = loadFromXML ("./ressources/drone.svg")
    
	FillColor dronefill (198, 198, 198)


	g << svgdrone

	shadow?1:0.5 =:> g.path_svg_drone.opacity 


	Spike rightclicked
	Spike item1Selected
	Spike item2Selected
	Spike item3Selected


	FSM rightclick {
		State idle
		State pressed
		State opened {
			Menu menu(this, $this.bg.press.x + $this.bg.width / 2, $this.bg.press.y + $this.bg.height / 2, "launch", "land", "hold")
		}
	idle -> pressed(bg.right.press)
	pressed -> opened(bg.right.release, rightclicked)
	opened -> idle(frame.press)
	opened -> idle(opened.menu.menuItem1Selected, item1Selected)
	opened -> idle(opened.menu.menuItem2Selected, item2Selected)
	opened -> idle(opened.menu.menuItem3Selected, item3Selected)
	opened -> idle(opened.menu.close)

	}

	item1Selected -> (this){
		this.dronefill.r = 0
		this.dronefill.g = 150
		this.dronefill.b = 150
	}

	item2Selected -> (this){
		this.dronefill.r = 150
		this.dronefill.g = 0
		this.dronefill.b = 150
	}
	item3Selected -> (this){
		this.dronefill.r = 150
		this.dronefill.g = 150
		this.dronefill.b = 0
	}

}