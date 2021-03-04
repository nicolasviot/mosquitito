
use core
use base
use display
use gui
import Map.utils.conversion.Gps2Screen
import Map.utils.conversion.Screen2Gps

_define_
Link(Process frame, Process firstdrone, Process seconddrone){

	NoFill _

	OutlineColor red (168, 0, 0)
	OutlineWidth witdh (5)


	Double intermediaryX(0)
	Double intermediaryY(0)
	Double dx(0)
	Double dy(0)
	Double drot(0)


	firstdrone.x + dx =:> seconddrone.x
	firstdrone.y + dy =:> seconddrone.y
	firstdrone.rot + drot =:> seconddrone.rot


	// firstdrone.x - ((firstdrone.x - seconddrone.x) * 3 / 4) =:> intermediaryX
	// firstdrone.y - ((firstdrone.y - seconddrone.y) * 1 / 2) =:> intermediaryY
	

	Path path{
		PathMove origin(0, 0)
		// PathQuadratic destination(0, 0, 0, 0)
		PathLine destination(0, 0)
	}


	firstdrone.cx =:> path.origin.x
	firstdrone.cy =:> path.origin.y
	seconddrone.cx =:> path.destination.x
	seconddrone.cy =:> path.destination.y
	// intermediaryX =:> path.destination.x1
	// intermediaryY =:> path.destination.y1

	// Path whatapathlooklike{
	// 	PathMove ori (1500, 500)
	// 	PathQuadratic dest (1400, 650, 1500, 800)
	// }

}
