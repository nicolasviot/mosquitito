use core
use base
use gui


_define_ 
MapArea (Process map_, Process areaPoints){
	//Drawing of the area
	map aka map_
	points aka areaPoints.points
	OutlineColor outlineColor (178,34,34)
	OutlineWidth outlineWidth (3)
	FillColor fillColor (178,34,34)
	FillOpacity opacity (0.2)
	Path area {
		PathMove _ ($points.[1].x, $points.[1].y)
		for(int i = 2 ; i <= $points.size ; i ++){
			PathLine _ ($points.[i].x, $points.[i].y)
		}
	}
	for(int i = 1; i <= $points.size; i++){
		toString(points.[i].x) =:> area.items.[i].x
		toString(points.[i].y) =:> area.items.[i].y
	}
	Spike enter
	Spike leave
	area.enter -> enter
	area.leave -> leave
	area.press -> map.clipping.press
	Spike show 
	Spike hide
	show -> area
	hide ->!area
}