use core
use base
use display
use gui

import Map.models.object.MobileObject
import Map.models.object.MyPlaneLabelObject

_define_
MyPlaneObject (double latitude_,double longitude_, Process map_){
	// Mobile object with a graphical component of a plane.
	MobileObject mobileObject (latitude_,longitude_,map_)
	longitude aka mobileObject.longitude
	latitude aka mobileObject.latitude
	futureLon aka mobileObject.futureLon
	futureLat aka mobileObject.futureLat
	bearing aka mobileObject.bearing
	map aka map_
	gc aka mobileObject.gc

	addChildrenTo gc {
		svg = loadFromXML ("./ressources/plane.svg")
		Scaling scaling (0.035,0.035,0,0)
		Translation t (-300,-270)
		Rotation r (0,300,270)
		full << svg.layer1
	}		
	Spike unselect
	Spike press
	gc.full.plane.press -> press
	FSM planeSelected {
		State notSelected
		State selected {
			Double deg2rad (0.01745329251994329576923690768489) // pi/180
			Int offset (50)
			Cosine cosA (0)
			mobileObject.bearing*deg2rad =:> cosA.input
			Sine sinA (0)
			mobileObject.bearing*deg2rad =:> sinA.input
			Double offsetX (0)
			offset*cosA.output =:> offsetX
			Double offsetY (0)
			offset*sinA.output =:> offsetY
			Component label {
				OutlineColor _ (10,0,0)
				OutlineWidth _ (4)
				Line line (0,0,0,0)
				mobileObject.t.tx =:> line.x1
				mobileObject.t.ty =:> line.y1
				line.x1 + offsetX =:> line.x2
				line.y1 + offsetY =:> line.y2
				MyPlaneLabelObject labelObject (latitude_,longitude_,map)
				line.x2 =:> labelObject.mobileObject.t.tx
				line.y2 =:> labelObject.mobileObject.t.ty
				FSM fsm {
				    State idle
				    State dragging {
				      Int off_x (0)
				      Int off_y (0)
				      labelObject.press_x- labelObject.mobileObject.t.tx =: off_x
				      labelObject.press_y - labelObject.mobileObject.t.ty =: off_y
				      map.frame.move.x - off_x => line.x2
				      map.frame.move.y - off_y => line.y2
				    }
				    idle->dragging (labelObject.press)
				    dragging->idle (map.frame.release)
				}
					
			}
			press -> unselect
		}
		notSelected -> selected (press)
		selected -> notSelected (unselect)
	}
	
	time aka planeSelected.selected.label.labelObject.time
	distance aka  planeSelected.selected.label.labelObject.dist
	time_unit aka planeSelected.selected.label.labelObject.time_unit
	distance_unit aka planeSelected.selected.label.labelObject.dist_unit
	showEverything aka planeSelected.selected.label.labelObject.showEverything
	showOnlyPast aka planeSelected.selected.label.labelObject.showOnlyPast
	showOnlyFuture aka planeSelected.selected.label.labelObject.showOnlyFuture
	follow aka planeSelected.selected.label.labelObject.follow
	unfollow aka planeSelected.selected.label.labelObject.unfollow
	follow -> (this){
		addChildrenTo this.map.layers {
			delete this.map.layers.bind
			Component bind {
				this.latitude =:> this.map.new_latitude
				this.longitude =:> this.map.new_longitude
				// this.mobileObject.bearing => this.map.orientation
			}
		}
	}

	unfollow -> (this){
		delete this.map.layers.bind
	}
	
	
	bearing =:> gc.r.a
}