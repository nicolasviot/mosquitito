use core
use base
use gui


_define_
InteractionStream (Process map){
	//stream used to create trajectory interactively
	frame aka map.frame
	Double latitude (0)
	map.lati_pointed =:> latitude
	Double longitude (0)
	map.longi_pointed =:> longitude
	Int heading (0)
	Int altitude (0)
	Spike end 
	Spike remove_


	Spike ctrl
	Spike ctrl_r
	frame.key\-pressed == 16777249-> ctrl
	frame.key\-released == 16777249-> ctrl_r
	FSM ctrlKeyFSM {
		State idle 
		State ctrlKey {
			map.press -> end
			frame.move -> map.pz.forceNoPan
			frame.key\-pressed == 90 -> remove_
		}
		idle -> ctrlKey (ctrl)
		ctrlKey -> idle (ctrl_r)
	}
}