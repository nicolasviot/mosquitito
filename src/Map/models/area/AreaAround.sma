use core
use base
use gui

import Map.models.point.PointGps

_define_ 
AreaAround (Process map_, Process point_, double radius_, string radius_unit_){
	map aka map_
	point aka point_
	Double radius ($radius_)
	String radius_unit (radius_unit_)
	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	Cosine cosLat ($point.latitude*$deg2rad)
	point.latitude*deg2rad =>cosLat.input
	Double mtodeg (1/(1000*111*$cosLat.output))
	1/(1000*111*cosLat.output) => mtodeg
	TextComparator m_comparator ("m","")
	radius_unit =:> m_comparator.right
	TextComparator km_comparator ("km","")
	radius_unit =:> km_comparator.right
	TextComparator nm_comparator ("nm","")
	radius_unit =:> nm_comparator.right
	PointGps p_around ($point.latitude, $point.longitude + $radius*$mtodeg, map)
	//FSM which allo the data flow with the units
	FSM changeUnit {
		State m{
			double conversion = 1
			point.longitude + radius*mtodeg*conversion =:> p_around.longitude
		} 
		State km{
			double conversion = 1000
			point.longitude + radius*mtodeg*conversion =:> p_around.longitude
		}
		State nm{
			double conversion = 1852
			point.longitude + radius*mtodeg*conversion =:> p_around.longitude
		}

		m -> km (km_comparator.output.true)
		m -> nm (nm_comparator.output.true)
		km -> m (m_comparator.output.true)
		km -> nm (nm_comparator.output.true)
		nm -> m (m_comparator.output.true)
		nm -> km (km_comparator.output.true)
	}

	addChildrenTo map.layers {
		OutlineColor outlineColor (178,34,34)
		OutlineWidth outlineWidth (3)
		FillColor fillColor (178,34,34)
		FillOpacity opacity (0.2)
		Circle area (0,0,0)
	}

	point.x =:> map.layers.area.cx
	point.y =:> map.layers.area.cy

	//Define the radius of the circle
	p_around.x - point.x =:> map.layers.area.r

}