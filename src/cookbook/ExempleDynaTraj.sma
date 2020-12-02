use core
use base
use gui


import Map.models.stream.SimuStream
import Map.models.trajectory.DynamicJourney
import Map.models.object.MobileObject
import Map.models.trajectory.TrajectorySteps
import Map.models.profile.MyFlightProfile

_define_
ExempleDynaTraj (Process map_){
	//Example to show how to plot a trajectory read from a csv file, line by line each X seconds
	map aka map_
	//Third arguments is the delay in milliseconds between two readings
	SimuStream stream (map, "./saved_trajectory/paris_new_york.csv", 200)
	stream =: map.stream_active
	//You must strictly follow the next steps in order to have the drawing  
	addChildrenTo map.layers {
		MobileObject object (0,0,map)
		addChildrenTo object.gc {
			Circle c (0,0,5)
		}
		TrajectorySteps trajectorySteps (map)
		DynamicJourney dynaTraj (map, stream, trajectorySteps,object,1200,10,450,450)
	}
}