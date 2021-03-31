/*
 *	djnn Smala compiler
 *
 *	The copyright holders for the contents of this file are:
 *		Ecole Nationale de l'Aviation Civile, France (2017)
 *	See file "license.terms" for the rights and conditions
 *	defined by copyright holders.
 *
 *
 *	Contributors:
 *		Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
 *
 */

use core
use base
use display
use gui
use comms

import Map.Map
import Map.widgets.MapController
import testPannel.TestPannel
import Map.models.object.MobileObject
import Map.widgets.Button
import cookbook.MarkerAdd
import Map.widgets.ConstraintBox
import Map.widgets.FlightPlan
import Map.widgets.ControlPannel

_main_
Component root {
	Frame frame ("Constraint Editor", 0, 0, 1920, 1080)
	//Enable mouseTracking
	mouseTracking =1
	Exit ex (0,1)
	frame.close->ex	
	//Simple map component (upper right)


	Map map(frame,"FR", 16, 43.462239, 1.272804, 0, $frame.width * 0.25, 0, $frame.width * 0.75, $frame.height * 0.75) 
	frame.width * 0.25 => map.t.tx
	MapController mapController (map)
	MarkerAdd markerAdd (map)
	//Test pannel
	
	ConstraintBox cstr(frame, "Contrainte 1", $frame.width * 0.24, 0, "X", "Y", "Z", "Heading")
	ControlPannel ctrlPannel(frame, 0, 0, $frame.width * 0.24, $frame.height * 0.30)
	ConstraintBox cstr2(frame, "Contrainte 2", $frame.width * 0.24, $frame.height * 0.30, "X", "Y", "Z", "Heading")
TestPannel testPannel(frame, map, $frame.width * 0.24, $frame.height * 0.75, $frame.width * 0.75, $frame.height * 0.25)
	
	

	60 =: cstr.xProp
	-60 =: cstr.yProp
	-60 =: cstr2.xProp 
	-60 =: cstr2.yProp
	cstr.xProp =:> testPannel.link1.dx
	cstr.yProp =:> testPannel.link1.dy
	cstr.headingProp =:> testPannel.link1.drot
	cstr2.xProp =:> testPannel.link2.dx
	cstr2.yProp =:> testPannel.link2.dy
	cstr2.headingProp =:> testPannel.link2.drot
	cstr.xProp => ctrlPannel.Xf1
	cstr.yProp => ctrlPannel.Yf1
	cstr2.xProp => ctrlPannel.Xf2
	cstr2.yProp	=> ctrlPannel.Yf2
	cstr.onSpike -> ctrlPannel.formationON1
	cstr.offSpike -> ctrlPannel.formationOFF1
	cstr2.onSpike -> ctrlPannel.formationON2
	cstr2.offSpike -> ctrlPannel.formationOFF2


	// cstr.xProp =:> testPannel.gridPannel.link1.dx
	// cstr.yProp =:> testPannel.gridPannel.link1.dy
	// cstr.headingProp =:> testPannel.gridPannel.link1.drot

	// cstr2.xProp =:> testPannel.gridPannel.link2.dx
	// cstr2.yProp =:> testPannel.gridPannel.link2.dy
	// cstr2.headingProp =:> testPannel.gridPannel.link2.drot

	LogPrinter log("debug : ")
	FSM pseudoBidirectionnal {
		State idle{

			cstr.xProp =:> testPannel.gridPannel.link1.dx
			cstr.yProp =:> testPannel.gridPannel.link1.dy
			cstr.headingProp =:> testPannel.gridPannel.link1.drot

			cstr2.xProp =:> testPannel.gridPannel.link2.dx
			cstr2.yProp =:> testPannel.gridPannel.link2.dy
			cstr2.headingProp =:> testPannel.gridPannel.link2.drot


		}

		State notidle{

			"entering grid to cstr" =: log.input

			testPannel.gridPannel.link1.dx =:> cstr.xProp
			testPannel.gridPannel.link1.dy =:> cstr.yProp

			testPannel.gridPannel.link2.dx	=:> cstr2.xProp  
			testPannel.gridPannel.link2.dy =:> cstr2.yProp
 


		}

		idle -> notidle (testPannel.gridPannel.bg.move)
		notidle -> idle (cstr.background.bg.move)
		notidle -> idle (cstr2.background.bg.move)

	}



	// bi directional binding ? move fsm
	
	// testPannel.gridPannel.link1.dx =:> cstr.xProp
	// testPannel.gridPannel.link1.dy =:> cstr.yProp

	// testPannel.gridPannel.link2.dx =:> cstr2.xProp
	// testPannel.gridPannel.link2.dy =:> cstr2.yProp
	
	FlightPlan fpl(frame, "Leader Flight Plan", 0, $frame.height * 0.30, $frame.width * 0.24, $frame.height * 0.70)

}



