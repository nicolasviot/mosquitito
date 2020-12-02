use core
use base
use gui

_define_ 
TimedMovement(Process trajectorySteps){
	//engine that allow the journey of an object on the trajectory to follow the seconds given in he csv file.
	steps aka trajectorySteps.steps
	map aka trajectorySteps.map

	Spike next
	Spike previous
	Spike forwardSpike
	Spike backwardSpike
	Int index (1)
	Int sec ($steps.[$index].time)
	index -> (this){
		int i = $this.index
		this.sec = $this.steps.[i].time
	}
	FSM changeWay {
		State forward{
			map.seconds == sec -> next
			map.timeAcceleration < 0 -> backwardSpike
		}
		State backward{
			(index > 2)? index - 1 : 1 =: index   
			map.seconds == sec -> previous
			map.timeAcceleration > 0 -> forwardSpike
		}
		forward -> backward (backwardSpike)
		backward -> forward (forwardSpike)
	}
	

	


}