use core
use base
use gui


_native_code_
%{
	#include <cmath>
%}

_define_
PolygonAround (Process trajectorySteps_,Process dynaTraj_){
	//Object that create a polygon around a trajectory in order to be able to select it 
	trajectorySteps aka trajectorySteps_
	steps aka trajectorySteps.steps
	angles aka trajectorySteps.angles
	map aka trajectorySteps.map
	dynaTraj aka dynaTraj_
	Ref ref (null)
	dynaTraj =: ref
	NoOutline _
	Polygon polygon{
		for(int i = 1; i <= 2*$steps.size; i++){
			Point p_ (0,0)
		}
	}
	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	// offset of the polygon around the path
	Int offset (10)

	for(int i = 1; i <= $steps.size; i++){
		int other_ind = $polygon.points.size - i + 1
		(steps.[i].x + offset*cos(angles.[i].output*deg2rad)) =:> polygon.points.[i].x
		(steps.[i].y + offset*sin(angles.[i].output*deg2rad)) =:> polygon.points.[i].y
		(steps.[i].x - offset*cos(angles.[i].output*deg2rad)) =:> polygon.points.[other_ind].x
		(steps.[i].y - offset*sin(angles.[i].output*deg2rad)) =:> polygon.points.[other_ind].y
	}
	if($steps.size >0){
		(this.steps.[1].x - this.offset*cos(this.angles.[1].output*this.deg2rad)) =:> this.polygon.points.[$this.polygon.points.size].x
		(this.steps.[1].y - this.offset*sin(this.angles.[1].output*this.deg2rad)) =:> this.polygon.points.[$this.polygon.points.size].y
	}

	polygon.press -> (this) {
		refObj = &this.map.obj_selected
		if(refObj != this.ref){
			this.dynaTraj.outlineColor.b = 250
			int size1 = 2*$this.map.obj_selected.$value.steps.size
			int size2 = $this.map.obj_selected.$value.polAround.polygon.points.size
			if( size1 != size2){
				run this.map.obj_selected.$value.endCreation
			}
			this.map.obj_selected.$value.outlineColor.b = 34
			stop this.map.stream_active.$value
			run this.map.obj_selected.$value.hideProfile
			this.map.obj_selected = &this.dynaTraj
			this.map.stream_active = &this.dynaTraj.stream
			this.map.profile_ref = &this.dynaTraj.profileRef
			run this.dynaTraj.stream
			run this.map.obj_selected.$value.showProfile
		}
	}
}