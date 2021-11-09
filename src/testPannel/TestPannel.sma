use core
use base
use display
use gui
use comms


import Map.widgets.Button
import Map.widgets.Drone
import Map.widgets.Link

_define_ 
TestPannel(Process frame, double _x, double _y, double _width, double _height, Process ivybus){


	FillColor bgColor (192, 192, 192)
	Rectangle bg (_x, _y, _width, _height)
	Double leader_lat(0)
	Double leader_lon(0)
	Double leader_rot(0)
	Double f1_lat(0)
	Double f1_lon(0)
	Double f1_rot(0)
	Double f2_lat(0)
	Double f2_lon(0)
	Double f2_rot(0)

	x aka bg.x
	y aka bg.y
	width aka bg.width
	height aka bg.height


    ivybus.in.regexGetLatLonL.[4] => leader_lat
    ivybus.in.regexGetLatLonL.[5] => leader_lon
    ivybus.in.regexGetLatLonL.[3] => leader_rot

    ivybus.in.regexGetLatLonF1.[4] => f1_lat
    ivybus.in.regexGetLatLonF1.[5] => f1_lon
    ivybus.in.regexGetLatLonF1.[3] => f1_rot


    ivybus.in.regexGetLatLonF2.[4] => f2_lat
    ivybus.in.regexGetLatLonF2.[5] => f2_lon
    ivybus.in.regexGetLatLonF2.[3] => f2_rot

}