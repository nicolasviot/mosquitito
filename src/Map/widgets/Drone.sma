
use core
use base
use display
use gui



_define_
Drone(Process frame, double _x, double _y, double _rotation){
	Translation _t(_x, _y)


	Rotation _r(_rotation, 0, 0)

	x aka _t.tx
	y aka _t.ty
	rot aka _r.a

	x + 20 =:> _r.cx
	y + 20 =:> _r.cy
	svgdrone  = loadFromXML ("./ressources/drone.svg")
	g << svgdrone
}