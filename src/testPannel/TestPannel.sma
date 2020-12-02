use core
use base
use display
use gui

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

    /*
	Button but2 (frame, "test ajout Trajectoire", $bg.x + 100, $bg.y + 50)
	but2.click -> (this){		
	}
	*/
}