use core
use base
use gui

_define_
MyCircleGraph (int r,Process profile_, int i){
	//ONLY USED IN THE PROFILE CHART
	OutlineColor outlineColor (10,10,10)
	Circle c (0,0,10)
	profile aka profile_
	frame aka profile.trajectorysteps.map.frame
	Spike bottom
	Spike top 
	Spike normal
	TextPrinter log
	FSM fsm {
		State idle
		State active{
			Int off_y (0)
		   	c.press.y - c.cy =: off_y
			FSM fsm {
				State dragAllowed {
					frame.move.y - off_y => c.cy
					c.cy <= profile.height - profile.usedHeight -> top 
					c.cy >= profile.height -> bottom
				}
				State dragDownAllowed {
					frame.move.y - off_y < 0 -> {frame.move.y -off_y =: c.cy}
					c.cy <= profile.height - profile.usedHeight -> top 
					c.cy > profile.height - profile.usedHeight -> normal
				}
				State dragUpAllowed {
		   			frame.move.y - off_y < 0 -> {frame.move.y -off_y =: c.cy}
		   			c.cy -> normal
				}
				dragAllowed -> dragDownAllowed (top)
				dragAllowed -> dragUpAllowed (bottom)
				dragDownAllowed -> dragAllowed (normal)
				dragUpAllowed -> dragAllowed (normal)
			}
		}
		idle->active (c.press)
	    active->idle (c.release)
	}
	Component bindings {
		int j  = i -1 
		((j)*profile.separationX +  profile.outlineWidth.width) =:> c.cx
		(profile.height -profile.steps.[i].altitude*profile.separationY ) =: c.cy
		c.cx =:> profile.curve.points.[i].x
		c.cy =:> profile.curve.points.[i].y
		c.release->{profile.maxAltitude + (0.25*profile.height - c.cy)*profile.maxAltitude/profile.usedHeight=: profile.steps.[i].altitude}
		top -> {profile.maxAltitude + 500 =: profile.maxAltitude}
		profile.separationY -> {(profile.height -profile.steps.[i].altitude*profile.separationY ) =: c.cy}
	}
	
	Spike del
	del -> (this){
		delete this.bindings
	}
}	
