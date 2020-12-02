use core
use base
use display
use gui


import Map.models.object.MobileObject
import Map.models.stream.InteractionStream
import Map.models.trajectory.DynamicJourney
import Map.models.trajectory.TrajectorySteps
import Map.models.profile.MyFlightProfile

_native_code_
%{
	#include "Map/cpp/write_csv.h"
%}

_action_
save_traj(Process p )
%{
	Process *data = (Process*) get_native_user_data (p);
	Process *ref = (Process*) data -> find_child("obj_selected");
	Process *dyna_traj = ((RefProperty*) ref)->get_value();
	Process *points = (Process *) dyna_traj->find_child("steps");
	int size = ((IntProperty*) points->find_child ("size"))->get_value ();
	vector<vector<double>> res ;
	for(int i = 0 ; i < size; i ++ ){
		vector<double> lat_lon_alt_time;
		Process * step = (Process*) points->find_child(to_string(i+1));
		double lat = ((DoubleProperty*) step->find_child ("latitude"))->get_value ();
		double lon = ((DoubleProperty*) step->find_child ("longitude"))->get_value ();
		int alt = ((IntProperty*) step->find_child("altitude"))->get_value ();
		lat_lon_alt_time.push_back(lat);
		lat_lon_alt_time.push_back(lon);
		lat_lon_alt_time.push_back(alt);
		lat_lon_alt_time.push_back(i+1);
		res.push_back(lat_lon_alt_time);
	}
	time_t now = time(0);
	tm *ltm = localtime(&now);
	int year = 1900 + ltm->tm_year;
	int month =   1 + ltm->tm_mon;
	int day = ltm->tm_mday;
	string hour = "" + to_string(ltm->tm_hour) + "_" +  to_string(ltm->tm_min) + "_" + to_string(ltm->tm_sec);
	string file_name = "./saved_trajectory/" + to_string(day) +"_" + to_string(month) + "_" + to_string(year) + "_" + hour + ".csv";
	if(res.size() > 0){
		write_gps_coords(file_name, res);
	}

%}

_define_
TrajectoryAdd (Process map_){
	//Big example of the use of the API and smala. It allow to create trajectory and store them in a csv file.
	// You can create multiple trajectory at the same time, edit them when you want by clicking on them.
	// It's also possible to modify the altitude of each waypoints by translating the circle in the flight's profile

	map aka map_
	frame aka map.frame
	obj_selected aka map.obj_selected
	stream_active aka map.stream_active
	profile_ref aka map.profile_ref

	//Use of a specific stream to allow to create a new waypoint each time ctrl+click is active
	InteractionStream stream (map)
	stream =: stream_active
	addChildrenTo map.layers {
		MobileObject object (0,0,map)
		addChildrenTo object.gc {
			Circle c (0,0,5)
		}
		TrajectorySteps trajectorySteps (map)
		DynamicJourney dynaTraj (map, stream, trajectorySteps,object,1200,10,450,450)
		dynaTraj =: obj_selected
		250 =: dynaTraj.outlineColor.b
	}

	NativeAsyncAction save_action (save_traj,this,1)
  	
	Spike ctrl
	Spike ctrl_r
	frame.key\-pressed == 16777249-> ctrl
	frame.key\-released == 16777249-> ctrl_r

	FSM ctrlKeyFSM {
		State idle 
		State ctrlKey {
			frame.key\-released == 83-> save_action
		}
		idle -> ctrlKey (ctrl)
		ctrlKey -> idle (ctrl_r)
	}
	//Allow to create a new trajectory on the map by pressing the  'n' key 
	frame.key\-pressed == 78 -> (this){
		stop this.stream_active.$value
		run this.map.obj_selected.$value.hideProfile
		double size1 = 2*$this.map.obj_selected.$value.steps.size
		double size2 = $this.map.obj_selected.$value.polAround.polygon.points.size
		// Allow the drawing of a polygon around the trajectory in order to be able to click on it and edit it 
		if( size1 != size2){
			run this.map.obj_selected.$value.endCreation
		}
		addChildrenTo this {
			InteractionStream stream (this.map)
			stream =: this.stream_active
			addChildrenTo this.map.layers {
				34 =: this.map.obj_selected.$value.outlineColor.b
				MobileObject object (0,0,this.map)
				addChildrenTo object.gc {
					Circle c (0,0,5)
				}
				TrajectorySteps trajectorySteps (this.map)
				DynamicJourney dynaTraj (this.map, stream, trajectorySteps,object,1200,10,450,450)
				dynaTraj =: this.obj_selected
				250 =: dynaTraj.outlineColor.b
			}
		}
	}

	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 600, "Press \"CTRL + CLICK \" to place marker for path")
	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 625, "Press \"CTRL + Z \" to erase the latest point of the current path")
	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 650, "Press \"N \" to make a new path")
	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 675, "Press \"CTRL + S \" to save the latest Trajectory")
	
}