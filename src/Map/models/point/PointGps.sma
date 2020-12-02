use core
use base
use display
use gui

import Map.utils.conversion.Gps2Screen

_define_ 
PointGps(double lat, double lon, Process map_){
	//Abstract object to get the screen poisition of a lat/lon
	//There is no graphic representation
	map aka map_
	Double latitude (lat)
	Double longitude (lon)
	Double x (0)
	Double y (0)

	Gps2Screen gps2Screen (map)
	latitude =:> gps2Screen.inputLat
	longitude =:> gps2Screen.inputLon
	gps2Screen.outputX =:> x
	gps2Screen.outputY =:> y
}