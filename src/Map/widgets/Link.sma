
use core
use base
use display
use gui


_define_
Link(Process frame, Process firstcomp, Process secondcomp){

	NoFill _

	OutlineColor red (255, 0, 0)
	OutlineWidth witdh (10)

	Double intermediaryX(0)
	Double intermediaryY(0)

	firstcomp.cx - (firstcomp.cx - secondcomp.cx) * 3 / 4 =:> intermediaryX
	firstcomp.cy - (firstcomp.cy - secondcomp.cy) * 1 / 2 =:> intermediaryY

	TextPrinter log
	firstcomp.cx =:> log.input
	firstcomp.cy =:> log.input
	intermediaryX =:> log.input
	intermediaryY =:> log.input
	secondcomp.cx =:> log.input
	secondcomp.cy =:> log.input
	// dump this
	Path mypath{
		// PathMove origine ($this.firstcomp.cx, $this.firstcomp.cy)
	    PathMove origine (1046, 239)
		
	    // PathQuadratic test ($intermediaryX, $intermediaryY, $secondcomp.cx, $secondcomp.cy)	
		PathQuadratic test ($intermediaryX, $intermediaryY, 1246, 539)	
		
		// PathMove origine (1046, 239)
		// PathQuadratic test (1196, 389, 1246, 539)
			
	}
	
	Path whatapathlooklike{
		PathMove ori (1500, 500)
		PathQuadratic dest (1400, 650, 1500, 800)
		
			
	}


// 	1046.000000
// 239.000000
// 1196.000000
// 389.000000
// 1246.000000
// 539.000000

}