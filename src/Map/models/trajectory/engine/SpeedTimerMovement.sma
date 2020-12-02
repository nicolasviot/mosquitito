use core
use base
use display
use gui

import Map.utils.computation.DistanceGps

_define_ 
SpeedTimerMovement(Process steps_, double speed_, int begIndex){
	//engine that triger each delay_time, but the delay_time is compute regarding of the speed given
	steps aka steps_
	Int index (0)
	//speed in km/h or kts
	Double speed (speed_)
	Clock distanceTimer (0)
	Int nextIndex (begIndex + 1)
	//if speed in km/h last argument = "km" if kts last argument = "nm"
	DistanceGps distanceCalculator (steps.[$index], steps.[$nextIndex], "km")
	Spike next
	Spike previous
	// TextPrinter ll
	distanceTimer.tick -> (this){
		double distance = $this.distanceCalculator.output
		// this.ll.input = "dist : "  + to_string(distance)
		double speed = $this.speed 
		// this.ll.input  = "vit : " + to_string(speed)
		double time = distance/speed*3600
		// this.ll.input = "time : "  + to_string(time)
		this.distanceTimer.delay = time*1000
		run this.next

		this.index = $this.index + 1
		this.nextIndex = $this.nextIndex + 1

		if($this.nextIndex < $this.steps.size){
			this.distanceCalculator.latitude1 = $this.steps.[$this.index].latitude
			this.distanceCalculator.longitude1 = $this.steps.[$this.index].longitude
			this.distanceCalculator.latitude2 = $this.steps.[$this.nextIndex].latitude
			this.distanceCalculator.longitude2 = $this.steps.[$this.nextIndex].longitude
			run this.distanceCalculator.compute
		}
	}
}