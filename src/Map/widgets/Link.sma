
use core
use base
use display
use gui

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
	Double headingset(0)

	firstdrone.x + dx =:> seconddrone.req_x
	firstdrone.y + dy =:> seconddrone.req_y
	firstdrone.rot + drot =:> seconddrone.rot


	// firstdrone.x - ((firstdrone.x - seconddrone.x) * 3 / 4) =:> intermediaryX
	// firstdrone.y - ((firstdrone.y - seconddrone.y) * 1 / 2) =:> intermediaryY
	Switch link_gc (visible) {
    Component hidden {
    }
    Component visible {
   
		Path path{
			PathMove origin(0, 0)
			// PathQuadratic destination(0, 0, 0, 0)
			PathLine destination(0, 0)
		} 
	}
  }


	firstdrone.cx =:> link_gc.visible.path.origin.x
	firstdrone.cy =:> link_gc.visible.path.origin.y
	seconddrone.cx =:> link_gc.visible.path.destination.x
	seconddrone.cy =:> link_gc.visible.path.destination.y


}
