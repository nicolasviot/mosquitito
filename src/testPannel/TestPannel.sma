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
import Map.widgets.ConstraintBox

_define_ 
TestPannel(Process frame, Process map, double _x, double _y, double _width, double _height){


	FillColor bgColor (192, 192, 192)
	Rectangle bg (_x, _y, _width, _height)

	x aka bg.x
	y aka bg.y
	width aka bg.width
	height aka bg.height
	map aka map	


	Button but (frame, "test ajout MobileObject", $bg.x + 50, $bg.y + 50)
	ConstraintBox cstr(frame, "Contrainte 1", 0, 0 , "X", "Y", "Z", "Heading")
	but.click -> (this) {
		
		addChildrenTo this.map.layers {
			MobileObject m (43.44918, 1.263429, this.map)
			addChildrenTo m.gc {
				Circle form (0, 0, 100)
			}
			
		}
	}
	
	addChildrenTo this.map.layers {
			MobileObject m1 (43.44918, 1.263429, this.map)
			addChildrenTo m1.gc {
				Circle form (0, 0, 2)
			}
			
		}


	/* ------- Log Printer to receive a Message in Terminal ---*/
    LogPrinter lp ("ivybus: latitude ")
    LogPrinter lp2 ("ivybus: longitude ")
	LogPrinter lp3 ("Block status : ")



	FillColor bg2 (192, 128, 64)
	Rectangle block1 ($bg.x + 50, $bg.y + 100, 20, 20)

	Rectangle block2 ($bg.x + 100, $bg.y + 100, 20, 20)

	Rectangle block3 ($bg.x + 150, $bg.y + 100, 20, 20)

	Rectangle block4 ($bg.x + 200, $bg.y + 100, 20, 20)
	Double dummy(21)

    IvyAccess ivybus ("127.255.255.255:2010", "smala", "READY")
    {
        // define your regexs 
        // better to use (\\S*) than (.*) eq: "pos=(\\S*) alt=(\\S*)"
        String regexGetLatLon ("ground NAV_STATUS 21 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberLeader ("21 NAVIGATION (.*)")
    	String regexGetBlockJump("gcs JUMP_TO_BLOCK (\\S*) (\\S*)")
    }

    //creating a connector to display incomming messages in the text
    ivybus.in.regexGetLatLon.[5] => lp.input
    ivybus.in.regexGetLatLon.[6] => lp2.input
    ivybus.in.regexGetLatLon.[5] => this.map.layers.m1.latitude

    ivybus.in.regexGetLatLon.[6] => this.map.layers.m1.longitude








    //ivybus.in.regex.[7] => lp.input

    //ivybus.in.regexGetBlockNumberLeader.[0] => lp3.input

    


    /*
	Button but2 (frame, "test ajout Trajectoire", $bg.x + 100, $bg.y + 50)
	but2.click -> (this){		
	}
	*/
}