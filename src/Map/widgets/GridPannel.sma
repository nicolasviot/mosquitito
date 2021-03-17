use core
use base
use display
use gui
use comms

import Map.widgets.Drone
import Map.widgets.Link

_define_
GridPannel(Process frame, double _x, double _y){

	Translation _t($_x, $_y)
	

	Rectangle bg(0, 0, 400, 300)
	svggrid = loadFromXML ("./ressources/grid400_300.svg")
	g << svggrid




	/*
		insert interface for 2 drones

	*/

	
	Drone droneLeader(frame, 190, 140 , 0)
	Drone droneFollower1(frame, 140, 200, 0)
	Drone droneFollower2(frame, 260, 200, 0)

	Link link1(frame, droneLeader, droneFollower1)
	Link link2(frame, droneLeader, droneFollower2)


	/* interface */
/*
	xL aka droneLeader.x
	yL aka droneLeader.y
	rotL aka droneLeader.drot

	xF1 aka droneFollower1.x
	yF1 aka droneFollower1.y
	rotF1 aka droneFollower1.drot

	xF2 aka droneFollower2.x
	yF2 aka droneFollower2.y
	rotF2 aka droneFollower2.drot


	

	Text(0, $_height * 0.95, "scale :1 unit = 1m")

*/
}
