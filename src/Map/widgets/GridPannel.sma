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
	DronePatatoidal droneFollower1(frame, 140 - $width/2, 200 - $height/2, 0, $_t.tx, $_t.ty)
	DronePatatoidal droneFollower2(frame, 260 - $width/2, 200 - $height/2, 0, $_t.tx, $_t.ty)


	
	240 =: droneFollower1.dronefill.g
	240 =: droneFollower1.dronefill.b	
	
	240 =: droneFollower2.dronefill.r

	Link link1(frame, droneLeader, droneFollower1)
	Link link2(frame, droneLeader, droneFollower2)

	Double maxXbound(150)
	Double maxYbound(150)
	Double minXbound(-150)
	Double minYbound(-150)
	Double buffX(0)
	Double buffY(0)
	
	
	FSM dragFollower1{
		State idle
		State drag{
			frame.move.x - _t.tx - droneFollower1.width / 2 -  droneLeader.x =:> buffX
			frame.move.y - _t.ty - droneFollower1.height / 2 - droneLeader.y =:> buffY

			(buffX>maxXbound)?maxXbound:(buffX<minXbound?minXbound:buffX) =:> this.link1.dx
			(buffY>maxYbound)?maxYbound:(buffY<minYbound?minYbound:buffY) =:> this.link1.dy
		}

		idle -> drag (droneFollower1.grand_patatoide.left.press)
		drag -> idle (droneFollower1.grand_patatoide.left.release)
		drag -> idle (droneFollower1.petit_patatoide.left.release)
	}
	

	FSM dragFollower2{
		State idle
		State drag{
			frame.move.x - _t.tx - droneFollower2.width / 2 -  droneLeader.x =:> buffX
			frame.move.y - _t.ty - droneFollower2.height / 2 -  droneLeader.y =:> buffY

			(buffX>maxXbound)?maxXbound:(buffX<minXbound?minXbound:buffX) =:> this.link2.dx
			(buffY>maxYbound)?maxYbound:(buffY<minYbound?minYbound:buffY) =:> this.link2.dy
		}

		idle -> drag (droneFollower2.grand_patatoide.left.press)
		drag -> idle (droneFollower2.grand_patatoide.left.release)
		drag -> idle (droneFollower2.petit_patatoide.left.release)
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
