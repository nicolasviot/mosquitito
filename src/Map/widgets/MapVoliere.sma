use core
use gui
use comms
use display
use base

import Map.widgets.PanAndZoomWidget
import Map.widgets.Drone


_define_
MapVoliere (Process frame, double _x, double _y, double _width, double _height){

Translation _t(_x, _y)
Spike addDrone
Double argX (50)
Double argY (50)
Double argRot (0)
FillColor fc(164, 164, 164)
Rectangle background(0, 0, _width, _height)

/*TODO lambda à débugger*/
addDrone -> (this) {
		addChildrenTo this{
			

			Drone drons(this.background, $this.argX, $this.argY, $this.argRot)
		}
	}



Homography smth()
PanAndZoomWidget panAndZoom(frame, background, smth)


}


