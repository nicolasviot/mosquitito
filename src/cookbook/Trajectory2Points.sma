use core
use base
use display
use gui

import Map.models.point.PointGps

_define_
Trajectory2Points ( Process map_){
	//Litlle example to show how to "simulate" a movement on a path without using trajectory
	map aka map_
	frame aka map.frame

	PointGps p1 (43.59569,1.452575,map)
	PointGps p2 (43.60569,1.442575,map)

	PointGps p ($this.map.lati_pointed,$this.map.longi_pointed,this.map)
	Rectangle r (0,0,20,20,10,10)
	p.x - r.width/2 =:> r.x 
	p.y -  r.height/2 =:> r.y 

	addChildrenTo map.layers {
		Rectangle r1 (0,0,20,20,10,10)
		p1.x - r1.width/2 =:> r1.x 
		p1.y -  r1.height/2 =:> r1.y 
		Rectangle r2 (0,0,20,20,10,10)
		p2.x - r2.width/2 =:> r2.x 
		p2.y -  r2.height/2 =:> r2.y 
	}
	Double slope (($p2.latitude - $p1.latitude)/($p2.longitude - $p1.longitude))
	AdderAccumulator  alpha (0,0,1)
	PointGps p_current ($p1.longitude , 0,map)
	slope*(p_current.longitude - p1.longitude) + p1.latitude =:> p_current.latitude 
	Spike pause

	AssignmentSequence incLon (1){
		p1.longitude + alpha.result*(p2.longitude - p1.longitude) =:>p_current.longitude 
		0.005 =: alpha.input
		if(p_current.longitude == p2.longitude){
			run pause
		}
	}

	Timer t (100)
	t.end -> incLon, t

	addChildrenTo map.layers {
		FillColor _ (255,0,0)
		Rectangle r3 (0,0,20,20,10,10)
		p_current.x - r3.width/2 =:> r3.x 
		p_current.y -  r3.height/2 =:> r3.y 
	}
	 
	pause ->! t 
	Spike unpause 
	unpause -> t

	Spike space
	frame.key\-pressed == 32 -> space,pause
	Spike ctrl
	Spike ctrl_r
	frame.key\-pressed == 16777249-> ctrl
	frame.key\-released == 16777249-> ctrl_r
	Spike toIdle

	FSM change {
		State idle 
		State changeLoc
		State controlKey{
			FSM relocate{
				State idle 
				State reloc
				idle -> reloc (space, unpause)
			}
		}
		idle -> changeLoc (space, pause)
		changeLoc -> controlKey (ctrl)
		controlKey -> idle (ctrl_r)
	}
	Text te ($map.t.tx, $map.t.ty + $map.clipping.height + 600, "Press \"SPACE\" to pause the trajectory")
	Text t2 ($map.t.tx, $map.t.ty + $map.clipping.height + 625, "Press \"CTRL + SPACE\" to resume trajectory ")
	Text t3 ($map.t.tx, $map.t.ty + $map.clipping.height + 650, "")
	"Actual coordinates : lat : " + p_current.latitude + " , lon : " +p_current.longitude =:>t3.text
	
}