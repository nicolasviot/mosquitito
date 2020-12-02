use core
use base
use display
use gui

_native_code_
%{
	#include<cmath>
%}

_define_ 
FixedTimerMovement(int time_delay,Process accelerationTimer,Process map){
	//Engine that trigger each "time_delay" milliseconds
	Clock clock ($accelerationTimer*(time_delay))
	1/abs(accelerationTimer)*(time_delay)=:> clock.period
	Spike next
	Spike previous
	Spike forwardSpike
	Spike backwardSpike
	Int index (0)
	FSM changeWay {
		State forward{
			clock.tick-> next
			accelerationTimer < 0 -> backwardSpike
		}
		State backward{
			clock.tick-> previous
			accelerationTimer > 0 -> forwardSpike
		}

		forward -> backward (backwardSpike)
		backward -> forward (forwardSpike)
	}
	map.paused.true ->! clock
	map.paused.false -> clock
}