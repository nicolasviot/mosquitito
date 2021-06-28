use core
use gui
use comms
use display
use base

import PanAndZoom
import Map.widgets.Drone


_define_
MapVoliere (Process frame, double _x, double _y, double _width, double _height){

Translation _t(_x, _y)
Spike addDrone


addDrone ->(this) (AddChildrenTo this.graphics{
		Drone _ (args)
	})


FillColor fc(164, 164, 164)
Rectangle background(0, 0, _width, _height)


Component graphics{
	Homography smth()
	PanAndZoom panAndZoom(frame, background, smth)



}


}






}