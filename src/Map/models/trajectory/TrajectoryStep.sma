use core
use base
use display
use gui


import Map.models.point.PointGps
// Abstract Object that represent a step in a trajectory
_define_ 
TrajectoryStep(Process map, double latitude_, double longitude_,int altitude_, int time_, double heading_){

	Double latitude (latitude_)
	Double longitude (longitude_)
	Double speed (0)
	Double heading (heading_)
	Int altitude (altitude_)

	Double x (0)
	Double y (0)
	Int time (time_)

	PointGps p (0,0,map)

	latitude =:> p.latitude
	longitude =:> p.longitude

	p.x =:> x
	p.y =:> y

}

_define_ 
TrajectoryStep(Process map, double latitude_,double longitude_, int altitude_,double heading_){

	Double latitude (latitude_)
	Double longitude (longitude_)
	Double speed (0)
	Double heading ($heading_)
	Int altitude (altitude_)

	Double x (0)
	Double y (0)
	Int time (0)

	PointGps p (0,0,map)

	latitude =:> p.latitude
	longitude =:> p.longitude

	p.x =:> x
	p.y =:> y

}
