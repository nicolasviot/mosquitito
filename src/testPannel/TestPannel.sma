use core
use base
use display
use gui
use comms


import Map.widgets.Button

_define_ 
PprzListener(Process frame, double _x, double _y, double _width, double _height){


	FillColor bgColor (192, 192, 192)
	Rectangle bg (_x, _y, _width, _height)

	x aka bg.x
	y aka bg.y
	width aka bg.width
	height aka bg.height
	Double lat_leader(0)
	Double lon_leader(0)
	Double rot_leader(0)

	Double lat_f1(0)
	Double lon_f1(0)
	Double rot_f1(0)

	Double lat_f2(0)
	Double lon_f2(0)
	Double rot_f2(0)

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
    ivybus.in.regexGetLatLonL.[4] => lat_leader
    ivybus.in.regexGetLatLonL.[5] => lon_leader
    ivybus.in.regexGetLatLonL.[3] => rot_leader

    ivybus.in.regexGetLatLonF1.[4] => lat_f1
    ivybus.in.regexGetLatLonF1.[5] => lon_f1
    ivybus.in.regexGetLatLonF1.[3] => rot_f1


    ivybus.in.regexGetLatLonF2.[4] => lat_f2
    ivybus.in.regexGetLatLonF2.[5] => lon_f2
    ivybus.in.regexGetLatLonF2.[3] => rot_f2

}