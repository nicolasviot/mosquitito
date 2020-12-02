use core
use base
use display
use gui

import Map.utils.computation.DistanceGps
//Application of the distance computing on an entire trajectory
_define_ 
TrajectoryDistanceGps (Process trajectorySteps,int index_, string unit_){
	steps aka trajectorySteps.steps
	String unit (unit_)
	Int index (index_)
	List distances {
		for (int i = 1; i < $steps.size; i ++){
			int next_index = i + 1
			DistanceGps d (steps.[i],steps.[next_index],toString(unit))
		}
	}

	for (int i = 1 ; i < $distances.size; i ++ ){
		toString(unit) => distances.[i].unit
	}

	Double output (0)

	Timer t (3)

	t.end -> (this){
		this.output = 0
		for (int k = $this.index; k <= $this.distances.size; k ++){
			double d = $this.distances.[k].output
			this.output = $this.output + d
		}
	}

	unit -> t
	index -> t


}