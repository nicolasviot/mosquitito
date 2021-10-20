use core
use base
use display
use gui
use comms

import Map.widgets.Drone
import Map.widgets.Link
import Map.widgets.DronePatatoidal

_define_
GridPannel(Process frame, double _x, double _y, Process ivybusgrid){

	Translation _t($_x, $_y)
	
	NoFill _
	Rectangle bg(0, 0, 400, 300)
	svggrid = loadFromXML ("./ressources/gridV2.svg")
	g << svggrid

	Double width(76)
	Double height(68)
	
	Drone droneLeader(frame, 190 - $width/2, 140 - $height/2 , 0)
	198 =: droneLeader.dronefill.r
	0 =: droneLeader.dronefill.g
	0 =: droneLeader.dronefill.b
	

	Drone droneFollower1(frame, 140 - $width/2, 200 - $height/2, 0)
	0 =:droneFollower1.dronefill.r
	198 =: droneFollower1.dronefill.g
	0 =: droneFollower1.dronefill.b

	Drone droneFollower2(frame, 260 - $width/2, 200 - $height/2, 0)
	0 =:droneFollower2.dronefill.r
	0 =: droneFollower2.dronefill.g
	198 =: droneFollower2.dronefill.b

	DronePatatoidal dronetest (frame, 190 - $width/2, 140 - $height/2, 0, $_t.tx, $_t.ty)
	
	Link link1(frame, droneLeader, dronetest)
    Link link2(frame, droneLeader, droneFollower2)

	Double maxXbound(150)
	Double maxYbound(150)
	Double minXbound(-150)
	Double minYbound(-150)
	Double buffX(0)
	Double buffY(0)
	FSM dragpatatoidal{
		State idle{
			//frame.move =:> pos0


		}
		State drag{

			// Modulo modx (0, 20)
			// frame.move.x - _t.tx - droneFollower1.width / 2 =:> modx.left
			// Modulo mody (0, 20)
			// frame.move.y - _t.ty - droneFollower1.height / 2 =:> mody.left

			// this.bg.move.x - _t.tx - droneFollower1.width / 2 - modx.result - droneLeader.x =:> this.link1.dx
			// this.bg.move.y - _t.ty - droneFollower1.height /2 - mody.result - droneLeader.y =:> this.link1.dy
			
			frame.move.x - _t.tx - dronetest.width / 2 -  dronetest.x =:> buffX
			frame.move.y - _t.ty - dronetest.height * 2 - dronetest.y =:> buffY

			(buffX>maxXbound)?maxXbound:(buffX<minXbound?minXbound:buffX) =:> this.link1.dx
			(buffY>maxYbound)?maxYbound:(buffY<minYbound?minYbound:buffY) =:> this.link1.dy
			//diff frame pos0
		}

		idle -> drag (dronetest.grand_patatoide.left.press)
		drag -> idle (dronetest.grand_patatoide.left.release)

	}
	/*
	FSM dragFollower1{
		State idle{
			//frame.move =:> pos0


		}
		State drag{

			// Modulo modx (0, 20)
			// frame.move.x - _t.tx - droneFollower1.width / 2 =:> modx.left
			// Modulo mody (0, 20)
			// frame.move.y - _t.ty - droneFollower1.height / 2 =:> mody.left

			// this.bg.move.x - _t.tx - droneFollower1.width / 2 - modx.result - droneLeader.x =:> this.link1.dx
			// this.bg.move.y - _t.ty - droneFollower1.height /2 - mody.result - droneLeader.y =:> this.link1.dy
			
			frame.move.x - _t.tx - droneFollower1.width / 2 -  droneLeader.x =:> buffX
			frame.move.y - _t.ty - droneFollower1.height * 2 - droneLeader.y =:> buffY

			(buffX>maxXbound)?maxXbound:(buffX<minXbound?minXbound:buffX) =:> this.link1.dx
			(buffY>maxYbound)?maxYbound:(buffY<minYbound?minYbound:buffY) =:> this.link1.dy
			//diff frame pos0
		}

		idle -> drag (droneFollower1.bg.left.press)
		drag -> idle (droneFollower1.bg.left.release)
	}
	*/

	FSM dragFollower2{
		State idle
		State drag{

			// Modulo modx (0, 20)
			// frame.move.x - _t.tx - droneFollower2.width / 2 =:> modx.left
			// Modulo mody (0, 20)
			// frame.move.y - _t.ty - droneFollower2.height / 2 =:> mody.left

			// frame.move.x - _t.tx - droneFollower2.width / 2 - modx.result - droneLeader.x =:> this.link2.dx
			// frame.move.y - _t.ty - droneFollower2.height /2 - mody.result - droneLeader.y =:> this.link2.dy

			frame.move.x - _t.tx - droneFollower2.width / 2 -  droneLeader.x =:> buffX
			frame.move.y - _t.ty - droneFollower2.height * 2-  droneLeader.y =:> buffY

			(buffX>maxXbound)?maxXbound:(buffX<minXbound?minXbound:buffX) =:> this.link2.dx
			(buffY>maxYbound)?maxYbound:(buffY<minYbound?minYbound:buffY) =:> this.link2.dy
		}

		idle -> drag (droneFollower2.bg.left.press)
		drag -> idle (droneFollower2.bg.left.release)
	}




	FSM shadowDisplayLeader{

		State idle {
			1 =: droneLeader.shadow
		}
		State shadowed {
			0 =: droneLeader.shadow
		}
		idle -> shadowed (droneLeader.bg.left.press)
		shadowed -> idle (droneLeader.bg.left.release)

	}
	


	Text legend(0, 300 * 0.95, "scale :1 unit = 1m")



    //creating a connector to display incomming messages in the text
    ivybusgrid.in.regexGetLatLonL.[3] => droneLeader.rot

    ivybusgrid.in.regexGetLatLonF1.[3] => droneFollower1.rot

    ivybusgrid.in.regexGetLatLonF2.[3] => droneFollower2.rot


}
