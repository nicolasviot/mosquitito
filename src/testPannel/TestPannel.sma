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

_define_ 
TestPannel(Process frame, Process map, double _x, double _y, double _width, double _height){


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
			Drone f2Drone(frame, 1200, 800, 0)
			0 =: f2Drone.dronefill.r
			0 =: f2Drone.dronefill.g
			198 =: f2Drone.dronefill.b
		}
	}

	//leaderDrone aka this.map.layers.leader.leaderDrone 
	//Link link1(frame, this.map.layers.leader.gc.leaderDrone, this.map.layers.follower1.gc.f1Drone)

	 //Link link2(frame, this.map.layers.leader.gc.leaderDrone, this.map.layers.follower2.gc.f2Drone)

	/* ------- Log Printer to receive a Message in Terminal ---*/
    LogPrinter lp ("latitude 21 ")
    LogPrinter lp2 ("latitude 22 ")
	LogPrinter lp3 ("latitude 23 ")
	LogPrinter lp4 ("slot message : ")


	FillColor bg2 (192, 128, 64)



    IvyAccess ivybus ("127.255.255.255:2010", "smalaTestPannel", "READY")
    {
 //        // define your regexs 
 //        // better to use (\\S*) than (.*) eq: "pos=(\\S*) alt=(\\S*)"
 //        //FLIGHT_PARAM (ID 11)
        
        String regexGetLatLonL ("ground FLIGHT_PARAM 21 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberL ("21 NAVIGATION (.*)")
        String regexGetLatLonF1 ("ground FLIGHT_PARAM 22 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberF1 ("22 NAVIGATION (.*)")
        String regexGetLatLonF2 ("ground FLIGHT_PARAM 23 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberF2 ("23 NAVIGATION (.*)")
    	String regexGetBlockJump("gcs JUMP_TO_BLOCK (\\S*) (\\S*)")
       


        }



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