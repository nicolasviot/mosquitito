use core
use base
use gui

import Map.models.point.PointGps

_define_
FixedObject (double latitude_,double longitude_, Process map){
 	Double longitude (longitude_)
	Double latitude (latitude_)

	PointGps p ($latitude,$longitude, map)

	Translation t (0,0)
	Scaling scaling (1,1,0,0)
	p.x =:> t.tx
	p.y =:> t.ty 
	Pow pow (1.05,0)
	map.zoom  =:> pow.exponent
	pow.result =:> scaling.sx,scaling.sy 

	Component gc {
		// add graphical component
	}

}