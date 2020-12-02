use core
use base
use display
use gui

import Map.models.point.PointGps
import Map.models.object.MobileObject

_define_
ExempleP1 (Process map){
	//Example to show how to define a mobile object, add a graphical representation and how to make it move

	addChildrenTo map.layers {
		MobileObject m (43.59569,1.452575,map)
	}

	addChildrenTo map.layers.m.gc {
		//Rectangle form (0,0,20,20,0,0)
		Circle form (0,0,10)
	}

	Spike space
	map.frame.key\-pressed == 32 -> space

	AssignmentSequence reLocation (1){
		map.layers.m.longitude + 0.001 =: map.layers.m.longitude
		map.layers.m.latitude + 0.002 =: map.layers.m.latitude
	}
	//Moving a mobile object is juste updating his latitude and longitude
	space -> reLocation
	
}