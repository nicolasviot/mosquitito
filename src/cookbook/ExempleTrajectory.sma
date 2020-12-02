use core
use base
use gui


import Map.models.object.MyPlaneObject
import Map.models.trajectory.MapTrajectoryDraw
import Map.models.trajectory.MapJourney
import Map.models.trajectory.TrajectorySteps
import Map.models.trajectory.engine.FixedTimerMovement
import Map.models.trajectory.engine.ManualMovement
import Map.models.trajectory.engine.SpeedTimerMovement
import Map.utils.computation.TrajectoryDistanceGps
import Map.utils.computation.TrajectoryTravelTimeGps
import Map.models.profile.MyFlightProfile
import Map.models.trajectory.MapTrajectory
_define_
ExempleTrajectory (Process map_){

	map aka map_
	
	//Wraper of the next declaration of a trajectory
	MapTrajectory mapTrajectory (map, "./saved_trajectory/paris_new_york.csv")
	//Change the place and the size of the chart

	// //Detailed definition of a trajectory
	TrajectorySteps trajectorySteps (map,"./saved_trajectory/paris_hong_kong.csv")
	trajectorySteps.endCreation -> (this){
		addChildrenTo this.map.layers {

			ManualMovement engine  // manualy activate next step 
			this.map.nextStep-> engine.next 
			this.map.previousStep -> engine.previous

			// FixedTimerMovement engine (1000,this.map.timeAcceleration,this.map) // timely activate next step (give the time delay)

			// SpeedTimerMovement engine (this.trajectorySteps.steps, 2000, 1) // movement calculated with the speed and the different waypoints

			//Create the drawing of the trajcetory on the map
			MapTrajectoryDraw MapTrajectoryDraw (this.map,this.trajectorySteps,"CDG-JFK")
			//Define the object you want to plot on the trajectory
			MyPlaneObject myPlaneObject (0,0,this.map)
			//Define the journey of the object on the trajectory, last argument is the index of the begining on the trajectory (1 is the first index)
			MapJourney mapJourney (this.map, this.trajectorySteps, MapTrajectoryDraw,myPlaneObject,engine,1)
			
			//Connector to allow the changing of display of the trajectory
			myPlaneObject.showOnlyFuture-> mapJourney.show_future
			myPlaneObject.showEverything-> mapJourney.show_everything
			myPlaneObject.showOnlyPast-> mapJourney.show_past

			//Additional ! Define the distance and the travel time left at each index of the journey
			TrajectoryDistanceGps dist (this.trajectorySteps, 1,"km")
			TrajectoryTravelTimeGps time (this.trajectorySteps,1, 1000, "km/h", "m")

			mapJourney.index =:> dist.index, time.index
			dist.output =:> myPlaneObject.distance
			dist.unit =:> myPlaneObject.distance_unit
			time.output =:> myPlaneObject.time
			time.time_unit =:> myPlaneObject.time_unit


			//Definition of the flight's profile 
			//If you don't want to have the profile comment the following lines 
			addChildrenTo this.map.otherComponents {
				MyFlightProfile profile (1200,10, 450,450, this.trajectorySteps)
			}
			stop this.map.otherComponents.profile
			myPlaneObject.press -> this.map.otherComponents.profile
			myPlaneObject.unselect ->! this.map.otherComponents.profile

		}
	}

	// //Here the constructor is different of the first one, because in this case it allow the showing of the flight's profile at the given coordinates
	MapTrajectory mapTrajectory1 (map, "./saved_trajectory/cdg_round.csv",1200,10,450,450)


	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 625, "Click on a plane to get more informations")



}