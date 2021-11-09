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

import testPannel.TestPannel
import Map.widgets.Button
import cookbook.MarkerAdd
import Map.widgets.ConstraintBox
import Map.widgets.FlightPlan
import Map.widgets.ControlPannel
import Map.widgets.GridPannel

_main_
Component root {
	Frame frame ("Drone Formation Editor", 0, 0, 1920, 1080)
	//Enable mouseTracking
	mouseTracking =1
	Exit ex (0,1)
	frame.close->ex	

	//background
	FillColor light_grey (48, 48, 48)
	Rectangle bg_constraint(0, 0, $frame.width * 0.24, $frame.height * 1 )
	ConstraintBox cstr(frame, "Contrainte 1", $frame.width * 0.015, $frame.height * 0.05, "X", "Y", "Z", "Heading")
	ControlPannel ctrlPannel(frame, 0, 0, $frame.width * 0.24, 0)
	ConstraintBox cstr2(frame, "Contrainte 2", $frame.width * 0.015,  $frame.height * 0.25, "X", "Y", "Z", "Heading")
	TestPannel testPannel(frame, $frame.width * 0.24, $frame.height, $frame.width * 0.75, $frame.height * 0.25)
	GridPannel gridPannel(frame, $frame.width * 0.015, $frame.height * 0.50)
	
	60 =: cstr.xProp
	-60 =: cstr.yProp
	-60 =: cstr2.xProp 
	-60 =: cstr2.yProp
	
	cstr.xProp => ctrlPannel.Xf1
	cstr.yProp => ctrlPannel.Yf1
	cstr2.xProp => ctrlPannel.Xf2
	cstr2.yProp	=> ctrlPannel.Yf2
	cstr.onSpike -> ctrlPannel.formationON1
	cstr.offSpike -> ctrlPannel.formationOFF1
	cstr2.onSpike -> ctrlPannel.formationON2
	cstr2.offSpike -> ctrlPannel.formationOFF2

	LogPrinter log("debug : ")
	FSM pseudoBidirectionnal {
		State idle{

			cstr.xProp =:> gridPannel.link1.dx
			cstr.yProp =:> .gridPannel.link1.dy
			cstr.headingProp =:> gridPannel.link1.drot

			cstr2.xProp =:> gridPannel.link2.dx
			cstr2.yProp =:> gridPannel.link2.dy
			cstr2.headingProp =:> gridPannel.link2.drot


		}

		State notidle{

			"entering grid to cstr" =: log.input

			gridPannel.link1.dx =:> cstr.xProp
			gridPannel.link1.dy =:> cstr.yProp

			gridPannel.link2.dx	=:> cstr2.xProp  
			gridPannel.link2.dy =:> cstr2.yProp
			
 


		}

		idle -> notidle (gridPannel.bg.move)
		notidle -> idle (cstr.background.bg.move)
		notidle -> idle (cstr2.background.bg.move)

	}


}



