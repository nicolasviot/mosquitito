use core
use base
use display
use gui

import Map.utils.computation.BearingGps
//Application of the bearing on an entire trajectory
_define_ 
TrajectoryBearingGps(Process trajectorysteps){
	steps aka trajectorysteps.steps
	List angles {
		for (int i = 1; i < $steps.size; i ++){
			int next_index = i + 1
			BearingGps a (steps.[i],steps.[next_index])
		}
		int prev_ind = $steps.size-1
		BearingGps a (steps.[prev_ind],steps.[$steps.size])
	}
}

