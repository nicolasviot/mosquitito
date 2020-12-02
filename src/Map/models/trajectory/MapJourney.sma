use core
use base
use gui

import Map.utils.computation.BearingGps
import Map.models.point.PointGps

_define_
MapJourney (Process map_, Process trajectorySteps, Process mapTrajectory,Process mobileObject_, Process engine_, int begIndex){
	//Object that manage a journey of an object on a particular trajectory
	map aka map_
	steps aka trajectorySteps.steps
	mobileObject aka mobileObject_
	engine aka engine_
	path aka mapTrajectory.path
 	
	Int index (begIndex)
	Double currentX ($steps.[$index].x)
	Double currentY ($steps.[$index].y)
	Double currentLat ($steps.[$index].latitude)
	Double currentLon ($steps.[$index].longitude)
	Double futureLat ($steps.[$index+1].latitude)
	Double futureLon ($steps.[$index+1].longitude)


	steps.[$index].x -> (this){
		this.currentX = this.steps.[$this.index].x
		this.currentY = this.steps.[$this.index].y
	}
	steps.[$index].y -> (this){
		this.currentX = this.steps.[$this.index].x
		this.currentY = this.steps.[$this.index].y
	}

	Spike next 
	next -> (this){
		if( $this.index < $this.steps.size){
			this.index = $this.index + 1
			this.currentX = this.steps.[$this.index].x
			this.currentY = this.steps.[$this.index].y
			this.currentLat = this.steps.[$this.index].latitude
			this.currentLon = this.steps.[$this.index].longitude
			if($this.index < $this.steps.size){
				int next_index = $this.index+1
				this.futureLat = this.steps.[next_index].latitude
				this.futureLon = this.steps.[next_index].longitude	
			}	
		}
		
	}
	Spike previous 
	previous -> (this){
		if($this.index > 1){
			this.index = $this.index - 1
			this.currentX = this.steps.[$this.index].x
			this.currentY = this.steps.[$this.index].y
			this.currentLat = this.steps.[$this.index].latitude
			this.currentLon = this.steps.[$this.index].longitude
			int next_index = $this.index+1
			this.futureLat = this.steps.[next_index].latitude
			this.futureLon = this.steps.[next_index].longitude	
		}
	}

	PointGps p (0,0, map)
	PointGps p_future (0,0,map)

	BearingGps bearingGps (p,p_future)
	bearingGps.output =:> mobileObject.bearing
	
	currentLat =:> mobileObject.latitude,p.latitude
	currentLon =:> mobileObject.longitude,p.longitude
	futureLon =:> p_future.longitude
	futureLat =:> p_future.latitude
	
	//Connection with the engine to move along the trajectory
	index =:> engine.index
	engine.next -> next
	engine.previous -> previous

	//The following line are here to be able to alter the display of the trajectory, if you want to see only the future trajectory or the past trajectory

	Spike show_everything
	Spike show_future
	Spike show_past

	show_everything -> (this){
		for(int i =1; i <= $this.path.points.size; i ++){
			run this.path.points.[i]
		}
	}
	show_future -> (this){
		for(int i =1; i < $this.index; i ++){
			stop this.path.points.[i]
		}
		for(int i = $this.index ; i<= this.path.points.size ; i ++){
			run this.path.points.[i]
		}
	}
	show_past -> (this){
		for(int i = $this.index+1 ; i<= this.path.points.size ; i ++){
			stop this.path.points.[i]
		}
		for(int i =1; i < $this.index; i ++){
			run this.path.points.[i]
		}
	}

	FSM showFSM {
		State showEverything
		State showFuture{
			index -> (this){
				int i = $this.index -1
				stop this.path.points.[i]
			}
		}
		State showPast{
			index -> (this){
				run this.path.points.[$this.index]
			}
		}
		showEverything -> showFuture (show_future)
		showEverything -> showPast (show_past)
		showFuture -> showEverything (show_everything)
		showFuture-> showPast (show_past)
		showPast-> showFuture (show_future)
		showPast -> showEverything (show_everything)

	}
}