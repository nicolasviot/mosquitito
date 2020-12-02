use core
use base
use display
use gui

import Map.utils.computation.TravelTimeGps
//Application of the time travel computation on an entire trajectory
_define_
TrajectoryTravelTimeGps (Process trajectorySteps, int index_ ,double speed_, string speed_unit_, string time_unit_){
	steps aka trajectorySteps.steps
	String speed_unit (speed_unit_)
	String time_unit (time_unit_)
	Double speed (speed_)
	Int index (index_)
	List times {
		for (int i = 1; i < $steps.size; i ++){
			int next_index = i + 1
			TravelTimeGps _ (steps.[i],steps.[next_index], $speed,toString(speed_unit), toString(time_unit))
		}
	}

	for (int i = 1 ; i < $times.size; i ++ ){
		toString(speed_unit) => times.[i].speed_unit
		toString(time_unit) => times.[i].time_unit
		toString(speed) => times.[i].speed
	}

	Double output (0)

	Timer t (3)

	t.end -> (this){
		this.output = 0
		double d = 0 
		for (int k = $this.index; k <= $this.times.size; k ++){
			d = $this.times.[k].output
			this.output = $this.output + d
		}
	}

	speed_unit -> t
	speed -> t
	time_unit -> t
	index -> t

}