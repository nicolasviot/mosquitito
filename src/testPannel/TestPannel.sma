use core
use base
use display
use gui
use comms

import Map.utils.sketching.MyCircle
import Map.utils.sketching.NewCircHandler
import Map.utils.sketching.MyRectangle
import Map.utils.sketching.NewRectHandler
import Map.models.point.PointGps
import Map.models.object.FixedPoint
import Map.models.object.MobileObject
import Map.widgets.Button
import Map.Map
import Map.widgets.MapController
import Map.widgets.Drone
import Map.widgets.Link
import Map.utils.conversion.Screen2Gps
import Map.models.object.FixedObject
import Map.utils.conversion.Gps2Screen

_define_ 
TestPannel(Process frame, Process map, double _x, double _y, double _width, double _height, Process ivybus){


	FillColor bgColor (192, 192, 192)
	Rectangle bg (_x, _y, _width, _height)

	x aka bg.x
	y aka bg.y
	width aka bg.width
	height aka bg.height
	map aka map	


	//Leader
	
	//Follower1
	
	//Follower2
	

	
	// Drone m2drone(frame, 1000, 200, 0)
	/*
	Drone m3drone(frame, 1200, 500, 0)
	*/
	
	Screen2Gps screen2Gps(this.map)

	addChildrenTo this.map.layers {
		MobileObject leader (43.44918, 1.263429, this.map)
		addChildrenTo leader.gc {
			Drone leaderDrone(frame, 0, 0, 0)
			198 =: leaderDrone.dronefill.r
			0 =: leaderDrone.dronefill.g
			0 =: leaderDrone.dronefill.b
		}
		MobileObject follower1 (43.44918, 1.263429, this.map)
		addChildrenTo follower1.gc{
			Drone f1Drone(frame, 0, 0, 0)
			0 =: f1Drone.dronefill.r
			198 =: f1Drone.dronefill.g
			0 =: f1Drone.dronefill.b
		}
		MobileObject follower2 (43.44918, 1.263429, this.map)
		addChildrenTo follower2.gc{
			Drone f2Drone(frame, 0, 0, 0)
			0 =: f2Drone.dronefill.r
			0 =: f2Drone.dronefill.g
			198 =: f2Drone.dronefill.b
		}
	}

	addChildrenTo this.map.layers {
		MobileObject dropZone(43.44918, 1.263429, this.map)
		addChildrenTo dropZone.gc{
			NoFill _
			OutlineColor light_green(24, 196, 24)
			Rectangle drop(0, 0, 100, 100)
		}	
	}



	// pour les drones "tangibles" =:> overlay puis D&D avec conversion en lat lon

	Drone leaderFixe(frame, _x, _y - 100, 0)

	198 =: leaderFixe.dronefill.r
	0 =: leaderFixe.dronefill.g
	0 =: leaderFixe.dronefill.b

	OutlineColor red (156, 0, 0)
	NoFill _


//encapsuler dans un fixedObject ixedObject (double latitude_,double longitude_, Process map){
	addChildrenTo this.map.layers{
		MobileObject targetContainer(43.44918, 1.263429, this.map)
		addChildrenTo targetContainer.gc{
			NoFill _ 
			OutlineColor blue (24, 24, 196)
			Rectangle encapsulatedTarget (0, 0, 200, 200)
		}
	}
	//TARGET
	Rectangle target(_x + 800, _y - 200, 200, 200)
	Spike leaderFixeReleased
	

	LogPrinter logcoord("screen coordinates")
	Gps2Screen targetConverter(this.map)
	this.map.layers.targetContainer.latitude =:> targetConverter.inputLat
	this.map.layers.targetContainer.longitude =:> targetConverter.inputLon

	targetConverter.outputX + " ; " + targetConverter.outputY =:> logcoord.input 



	LogPrinter logger("")
	Double onTarget(0)
	FSM dragleaderFixe{
		State idle{

		}
		State dragging{
			NoOutline _
			Drone shadowLeaderFixe(frame, $frame.move.x, $frame.move.y, 0)

			198 =: shadowLeaderFixe.dronefill.r
			0 =: shadowLeaderFixe.dronefill.g
			0 =: shadowLeaderFixe.dronefill.b
			0 =: shadowLeaderFixe.shadow
			frame.move.x  - 50=:> shadowLeaderFixe.x
			frame.move.y - 50=:> shadowLeaderFixe.y
			($targetConverter.outputX < $frame.move.x) && ($frame.move.x < $targetConverter.outputX + $target.width) && ($targetConverter.outputY < $frame.move.y) && ($frame.move.y < $targetConverter.outputY + $target.height)?1:0 =:> onTarget
			
			// ($target.x < $frame.move.x) && ($frame.move.x < $target.x + $target.width) && ($target.y < $frame.move.y) && ($frame.move.y < $target.y + $target.height)?1:0 =:> onTarget
			
		}
		idle -> dragging (leaderFixe.bg.left.press)
		dragging -> idle (dragging.shadowLeaderFixe.bg.release, leaderFixeReleased)
	}

leaderFixeReleased -> (this){

	//doSmth
	 this.logger.input = this.onTarget?"dropped on target":"dropped outside of target"
	// this.logger.input = "machin"
}


// leaderFixeReleased -> (this){
// 	addChildrenTo this{
// 		NoOutline _ 
// 		Drone dummynewdrone(this.frame, $this.x +400, $this.y - 600, 0)
// 	}
//  }

	// addChildrenTo this.map.layers {
	// 	MobileObject leaderFixe(43.44918, 1.263429, this.map)
	// 	addChildrenTo leaderFixe.gc{
	// 		Drone leaderFixeDrone (frame, 0, 0, 0)
	// 		198 =: leaderFixeDrone.dronefill.r
	// 		0 =: leaderFixeDrone.dronefill.g
	// 		0 =: leaderFixeDrone.dronefill.b
	// 	}
	// }
	// 20 =:> screen2Gps.inputX
	// 20 =:> screen2Gps.inputY

	// screen2Gps.outputLon =:> this.map.layers.leaderFixe.longitude

	// screen2Gps.outputLat =:> this.map.layers.leaderFixe.latitude

	//leaderDrone aka this.map.layers.leader.leaderDrone 
	//Link link1(frame, this.map.layers.leader.gc.leaderDrone, this.map.layers.follower1.gc.f1Drone)

	 //Link link2(frame, this.map.layers.leader.gc.leaderDrone, this.map.layers.follower2.gc.f2Drone)

	/* ------- Log Printer to receive a Message in Terminal ---*/
    LogPrinter lp ("latitude 21 ")
    LogPrinter lp2 ("latitude 22 ")
	LogPrinter lp3 ("latitude 23 ")
	LogPrinter lp4 ("slot message : ")


	FillColor bg2 (192, 128, 64)




 //    //creating a connector to display incomming messages in the text
    ivybus.in.regexGetLatLonL.[4] => this.map.layers.leader.latitude
    ivybus.in.regexGetLatLonL.[5] => this.map.layers.leader.longitude
    ivybus.in.regexGetLatLonL.[3] => this.map.layers.leader.gc.leaderDrone.rot

    ivybus.in.regexGetLatLonF1.[4] => this.map.layers.follower1.latitude
    ivybus.in.regexGetLatLonF1.[5] => this.map.layers.follower1.longitude
    ivybus.in.regexGetLatLonF1.[3] => this.map.layers.follower1.gc.f1Drone.rot


    ivybus.in.regexGetLatLonF2.[4] => this.map.layers.follower2.latitude
    ivybus.in.regexGetLatLonF2.[5] => this.map.layers.follower2.longitude
    ivybus.in.regexGetLatLonF2.[3] => this.map.layers.follower2.gc.f2Drone.rot

}