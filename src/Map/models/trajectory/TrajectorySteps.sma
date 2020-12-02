use core
use base
use display
use gui


import Map.models.trajectory.TrajectoryStep
import Map.utils.computation.TrajectoryBearingGps


_native_code_
%{
	#include "Map/cpp/read_csv.h"
%}

_action_
create_steps(Process p)
%{
	Process *src = (Process*) get_native_user_data (p);
	Process *data = new List(src, "data");
	string path = ((AbstractProperty*) src->find_child ("path"))->get_string_value();
	vector<vector<double>> res = get_path_data(path);
	for(int i = 0; i < res.size(); i ++){
		Process* lat = new DoubleProperty (data, "_", (res[i][0]));
		Process* lon = new DoubleProperty (data, "_", (res[i][1]));
		Process* alt = new IntProperty (data, "_", (res[i][2]));
		Process* time = new IntProperty (data, "_", res[i][3]);
	}
%}
//Object that parse a csv file and create a list of trajectorystep corresponding
_define_ 
TrajectorySteps(Process map_, string path_){
	map aka map_
	String path ($path_)
	NativeAsyncAction create_steps_action (create_steps,this,0)
	List steps
	Spike endCreation
	create_steps_action.end -> (this){
		for(int i = 0; i < $this.data.size/4; i++){
			int j = i+1
			int i1 = 4*i+1
			int i2 = 4*i + 2
			int i3 = 4*i + 3
			int i4 = 4*(i+1)
			addChildrenTo this.steps{
				TrajectoryStep _ (this.map,$this.data.[i1], $this.data.[i2],$this.data.[i3], $this.data.[i4],0)	
			}
		}
		addChildrenTo this {
			TrajectoryBearingGps trajectoryBearingGps (this)
			angles aka trajectoryBearingGps.angles
		}
		run this.endCreation
		delete this.data
	}
}

_define_
TrajectorySteps (Process map_){
	map aka map_
	List steps
	Spike makeAngles
	Spike endAngles 
	makeAngles -> (this){
		addChildrenTo this {
			TrajectoryBearingGps trajectoryBearingGps (this)
			angles aka trajectoryBearingGps.angles
		}
		run this.endAngles
	}
}
