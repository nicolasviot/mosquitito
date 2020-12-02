use core
use base
use gui

import Map.models.trajectory.TrajectoryStep
import Map.models.trajectory.TrajectorySteps
import Map.models.trajectory.PolygonAround
import Map.models.profile.MyFlightProfile

_native_code_
%{
	#include <cmath>
%}

_define_
DynamicJourney (Process map_, Process stream_, Process trajectorySteps_, Process mobileObject_){
	//Create a dynamic journey without a flight's profile
	map aka map_
	mobileObject aka mobileObject_
	stream aka stream_
	trajectorySteps aka  trajectorySteps_
	steps aka trajectorySteps.steps
	TrajectorySteps empty_traj (map)
	PolygonAround polAround (empty_traj,this)
	OutlineColor outlineColor (178,34,34)
	OutlineWidth outlineWidth (5) 
	NoFill _ 
	Polyline path 
	Double currentLat (0)
	Double currentLon (0)
	Int currentHeading (0)
	currentLat =:> mobileObject.latitude
	currentLon =:> mobileObject.longitude 
	currentHeading =:> mobileObject.bearing
	List bindingsTraj 
	//each time a stream trigger is end Spike a new point is added to the trajectory
	stream.end -> (this){
		addChildrenTo this.path {
			Point p (0,0)
		}
		addChildrenTo this.trajectorySteps.steps {
			TrajectoryStep traj (this.map,$this.stream.latitude,$this.stream.longitude, $this.stream.altitude,$this.stream.heading)	
			addChildrenTo this.bindingsTraj {
				Component _ {
					traj.x =:> this.path.p.x
					traj.y =:> this.path.p.y
					this.currentLat = traj.latitude 
					this.currentLon = traj.longitude
					this.currentHeading = $traj.heading 
				}
			}
		}
	}
	//each time a stream trigger is remove_ Spike the last point added is removed
	stream.remove_ -> (this){
		if($this.path.points.size > 0){
			int i  = $this.steps.size-1
			if($this.path.points.size > 1){
				this.currentLat = this.steps.[i].latitude
				this.currentLon = this.steps.[i].longitude
			}else{
				this.currentLat = 2000
				this.currentLon = 2000
			}
			delete this.polAround
			addChildrenTo this {
				PolygonAround polAround (this.empty_traj,this)
			}
			delete this.trajectorySteps.trajectoryBearingGps 
			delete this.bindingsTraj.[$this.bindingsTraj.size]
			delete this.path.points.[$this.path.points.size]
			delete this.steps.[$this.steps.size]
		}
	}
	//the following line allow to create a polygon around the trajectory in order to be selected.
	Spike endCreation
	endCreation -> trajectorySteps.makeAngles
	trajectorySteps.endAngles -> (this){
		delete this.polAround
		addChildrenTo this {
			PolygonAround polAround (this.trajectorySteps,this)
		}
	}
}

_define_
DynamicJourney (Process map_, Process stream_, Process trajectorySteps_, Process mobileObject_, int x_, int y_, int width_, int height_){
	//Same as previous but here a flight's profile is also added to the frame
	// the last four arguments are the position and dimension of the flight's profile chart.
	map aka map_
	mobileObject aka mobileObject_
	stream aka stream_
	trajectorySteps aka  trajectorySteps_
	steps aka trajectorySteps.steps
	Int x (x_)
	Int y (y_)
	Int width (width_)
	Int height (height_)
	TrajectorySteps empty_traj (map)
	PolygonAround polAround (empty_traj,this)
	Ref profileRef (null)
	OutlineColor outlineColor (178,34,34)
	OutlineWidth outlineWidth (5) 
	NoFill _ 
	Polyline path 
	Double currentLat (0)
	Double currentLon (0)
	Int currentHeading (0)
	currentLat =:> mobileObject.latitude
	currentLon =:> mobileObject.longitude 
	currentHeading =:> mobileObject.bearing
	List bindingsTraj 
	stream.end -> (this){
		addChildrenTo this.path {
			Point p (0,0)
		}
		addChildrenTo this.trajectorySteps.steps {
			TrajectoryStep traj (this.map,$this.stream.latitude,$this.stream.longitude, $this.stream.altitude,$this.stream.heading)	
			addChildrenTo this.bindingsTraj {
				Component _ {
					traj.x =:> this.path.p.x
					traj.y =:> this.path.p.y
					this.currentLat = traj.latitude 
					this.currentLon = traj.longitude
					this.currentHeading = $traj.heading 
				}
			}
		}
		run this.profileRef.$value.add
	}
	stream.remove_ -> (this){
		if($this.path.points.size > 0){
			int i  = $this.steps.size-1
			if($this.path.points.size > 1){
				this.currentLat = this.steps.[i].latitude
				this.currentLon = this.steps.[i].longitude
			}else{
				this.currentLat = 2000
				this.currentLon = 2000
			}
			delete this.polAround
			addChildrenTo this {
				PolygonAround polAround (this.empty_traj,this)
			}
			delete this.trajectorySteps.trajectoryBearingGps 
			delete this.profileRef.$value.points.[$this.profileRef.$value.points.size]
			delete this.profileRef.$value.curve.points.[$this.profileRef.$value.curve.points.size]
			delete this.bindingsTraj.[$this.bindingsTraj.size]
			delete this.path.points.[$this.path.points.size]
			delete this.steps.[$this.steps.size]
		}
	}
	
	Spike endCreation
	endCreation -> trajectorySteps.makeAngles
	trajectorySteps.endAngles -> (this){
		delete this.polAround
		addChildrenTo this {
			PolygonAround polAround (this.trajectorySteps,this)
		}
	}
	
	Spike hideProfile 
	Spike showProfile
	Spike endProfileCreation
	addChildrenTo map.otherComponents {
		MyFlightProfile profile ($x,$y, $width,$height, trajectorySteps)
		profile =: profileRef 
		profileRef =:map.profile_ref
		run endProfileCreation	
	}	
	hideProfile ->! map.otherComponents.profile.curve, map.otherComponents.profile.points, map.otherComponents.profile.chart
	showProfile -> map.otherComponents.profile.curve, map.otherComponents.profile.points, map.otherComponents.profile.chart
}