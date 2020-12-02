use core
use base
use gui

import Map.models.object.MyCircleGraph

_define_
MyFlightProfile (int x_,int y_,int width_,int height_,Process trajectorysteps_){
	//chart that plot the altitude of a flight at each waypoint
	trajectorysteps aka trajectorysteps_
	steps aka trajectorysteps.steps
	Translation t (x_,y_)
	x aka t.tx 
	y aka t.ty
	Int height ($height_)
	Int width ($width_)
	Int index (0)
	Double separationX (0) 
	Double separationY (0)
	Int maxAltitude (1000)
	Double usedHeight (0)
	Int size (0)
	height*0.75 =:> usedHeight
	(maxAltitude > 0 )? usedHeight/(maxAltitude): height =:> separationY
	(steps.size > 0) ? width/steps.size : 1 =:> separationX
	OutlineWidth outlineWidth (3)
	OutlineColor col (10,10,10)
	Component chart {	
		Line abscissa (0,$height,$width,$height)
		Line ordina (0,0,0, $height)
	 	Text maxText (-15,height*0.25,"")
	 	Text midText (-15,height*0.625,"")
	 	Text midUpText (-15,height*0.4375,"")
	 	Text midDownText (-15,height*0.8125,"")
	 	Text time ($width,$height +5,"time")
	 	Text alt (10,10,"altitude")
	 	Int midAlt (0)
	 	Int midUpAlt (0)
	 	Int midDownAlt (0)
	 	maxAltitude/2 =:> midAlt
	 	maxAltitude/4 =:> midDownAlt
	 	maxAltitude*3/4 =:> midUpAlt
	 	maxAltitude =:> maxText.text
	 	midAlt =:> midText.text
	 	midDownAlt =:> midDownText.text
	 	midUpAlt =:> midUpText.text
	}

	NoFill _
	OutlineWidth outlineWidthCurve (3)
	OutlineColor colCurve (105,105,105)
	Polyline curve {
		for (int i = 1 ; i <= $steps.size; i++){
			Point _ (0,0)
		}
	}
	for(int i = 1; i <= $steps.size; i++){
		maxAltitude = ($steps.[i].altitude > $maxAltitude) ? $steps.[i].altitude : $maxAltitude
		((i-1)*separationX +  outlineWidth.width) =:> curve.points.[i].x
		(height - steps.[i].altitude*separationY ) =:> curve.points.[i].y
	}
	List points 

	Spike add 
	add -> (this){
		int i  = $this.steps.size
		this.maxAltitude = ($this.steps.[i].altitude > $this.maxAltitude) ? $this.steps.[i].altitude : $this.maxAltitude
		addChildrenTo this.curve {
			Point _ (0,0)
		}
		addChildrenTo this.points{
			MyCircleGraph c (10,this, i)
		}
	}
}
