
use core
use base
use display
use gui



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

	x aka _t.tx
	y aka _t.ty
	rot aka _r.a
	x + width / 2 =:> cx
	y + height / 2 =:> cy
	width / 2 =:> _r.cx
    height / 2 =:> _r.cy
	svgdrone  = loadFromXML ("./ressources/drone.svg")
	g << svgdrone
}