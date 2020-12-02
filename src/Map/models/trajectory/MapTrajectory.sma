use core
use base
use gui


import Map.models.object.MyPlaneObject
import Map.models.profile.MyFlightProfile
import Map.models.trajectory.MapTrajectoryDraw
import Map.models.trajectory.MapJourney
import Map.models.trajectory.TrajectorySteps
import Map.models.trajectory.engine.TimedMovement
import Map.utils.computation.TrajectoryDistanceGps

_define_
MapTrajectory (Process map_,string path){
	//Wraper of the creation of a trajectory
	map aka map_
	TrajectorySteps trajectorySteps (map,path)
	Spike endCreation
	trajectorySteps.endCreation -> (this){
		addChildrenTo this.map.layers {

			TimedMovement engine (this.trajectorySteps)  

			MapTrajectoryDraw MapTrajectoryDraw (this.map,this.trajectorySteps,"")

			MyPlaneObject myPlaneObject (0,0,this.map)
			MapJourney mapJourney (this.map, this.trajectorySteps, MapTrajectoryDraw,myPlaneObject,engine,1)
			
			myPlaneObject.showOnlyFuture-> mapJourney.show_future
			myPlaneObject.showEverything-> mapJourney.show_everything
			myPlaneObject.showOnlyPast-> mapJourney.show_past

			TrajectoryDistanceGps dist (this.trajectorySteps, 1,"km")

			mapJourney.index =:> dist.index
			dist.output =:> myPlaneObject.distance
			dist.unit =:> myPlaneObject.distance_unit
		
			// mapJourney.index -> {this.trajectorySteps.steps.[$this.trajectorySteps.steps.size].time - this.trajectorySteps.steps.[$mapJourney.index].time=: myPlaneObject.time}
			// mapJourney.index -> (this){
			// 	int i = $mapJourney.index
			// 	this.myPlaneObject.time = 
			// }
			"s"=:> myPlaneObject.time_unit
		}
		
	}
}

_define_
MapTrajectory (Process map_,string path, int x_, int y_, int width_, int height_ ){
	map aka map_
	Int x (x_)
	Int y (y_)
	Int width (width_)
	Int height (height_)
	TrajectorySteps trajectorySteps (map,path)
	Spike endCreation
	trajectorySteps.endCreation -> (this){
		addChildrenTo this.map.layers {

			TimedMovement engine (this.trajectorySteps)  

			MapTrajectoryDraw MapTrajectoryDraw (this.map,this.trajectorySteps,"")

			MyPlaneObject myPlaneObject (0,0,this.map)
			MapJourney mapJourney (this.map, this.trajectorySteps, MapTrajectoryDraw,myPlaneObject,engine,1)
			
			myPlaneObject.showOnlyFuture-> mapJourney.show_future
			myPlaneObject.showEverything-> mapJourney.show_everything
			myPlaneObject.showOnlyPast-> mapJourney.show_past

			TrajectoryDistanceGps dist (this.trajectorySteps, 1,"km")

			mapJourney.index =:> dist.index
			dist.output =:> myPlaneObject.distance
			dist.unit =:> myPlaneObject.distance_unit
		
			// mapJourney.index -> {this.trajectorySteps.steps.[$this.trajectorySteps.steps.size].time - this.trajectorySteps.steps.[$mapJourney.index].time=: myPlaneObject.time}
			// mapJourney.index -> (this){
			// 	int i = $mapJourney.index
			// 	this.myPlaneObject.time = 
			// }
			"s"=:> myPlaneObject.time_unit
			addChildrenTo this.map.otherComponents {
				MyFlightProfile profile ($this.x,$this.y, $this.width,$this.height, this.trajectorySteps)
				run this.endCreation
			}
			stop this.map.otherComponents.profile
			myPlaneObject.press -> this.map.otherComponents.profile
			myPlaneObject.unselect ->! this.map.otherComponents.profile

		}
		
	}
}