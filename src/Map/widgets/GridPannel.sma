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
	
	FSM dragLeader{
		State idle
		State drag{

			Modulo modx (0, 20)
			this.bg.move.x - _t.tx - droneLeader.width / 2 =:> modx.left
			Modulo mody (0, 20)
			this.bg.move.y - _t.ty - droneLeader.height / 2 =:> mody.left

			this.bg.move.x - _t.tx - droneLeader.width / 2 - modx.result =:> droneLeader.x
			this.bg.move.y - _t.ty - droneLeader.height /2 - mody.result =:> droneLeader.y
		}

		idle -> drag (droneLeader.bg.press)
		drag -> idle (droneLeader.bg.release)
	}

	FSM dragFollower1{
		State idle
		State drag{

			Modulo modx (0, 20)
			this.bg.move.x - _t.tx - droneFollower1.width / 2 =:> modx.left
			Modulo mody (0, 20)
			this.bg.move.y - _t.ty - droneFollower1.height / 2 =:> mody.left

			this.bg.move.x - _t.tx - droneFollower1.width / 2 - modx.result - droneLeader.x =:> this.link1.dx
			this.bg.move.y - _t.ty - droneFollower1.height /2 - mody.result - droneLeader.y =:> this.link1.dy
		}

		idle -> drag (droneFollower1.bg.press)
		drag -> idle (droneFollower1.bg.release)
	}

	FSM dragFollower2{
		State idle
		State drag{

			Modulo modx (0, 20)
			this.bg.move.x - _t.tx - droneFollower2.width / 2 =:> modx.left
			Modulo mody (0, 20)
			this.bg.move.y - _t.ty - droneFollower2.height / 2 =:> mody.left

			this.bg.move.x - _t.tx - droneFollower2.width / 2 - modx.result - droneLeader.x =:> this.link2.dx
			this.bg.move.y - _t.ty - droneFollower2.height /2 - mody.result - droneLeader.y =:> this.link2.dy
		}

		idle -> drag (droneFollower2.bg.press)
		drag -> idle (droneFollower2.bg.release)
	}


	
	


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


*/	

	Text legend(0, 300 * 0.95, "scale :1 unit = 1m")


}
