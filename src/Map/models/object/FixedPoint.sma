use core
use base
use gui

import Map.models.point.PointGps

_define_
FixedPoint (double latitude_,double longitude_, Process map){
	//Fixed point ready to use
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
	FillColor fc (0,0,0)
	Component gc {
		Circle c (0,0,5)
	}

}