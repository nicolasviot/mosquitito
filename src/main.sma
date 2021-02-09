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
	// Button but (frame, "TAKEOFF !", 50, 50)
	//IvyAccess ivybustest ("127.255.255.255:2010", "smala takeoff", "READY")
	//but.click -> {
	//"ground JUMP_TO_BLOCK 21 3" =:root.ivybustest.out
	//}
	// "GO_TO_BLOCK 4 1" =: root.ivybustest.out
	//Reader Component
	//Test pannel
	
	TestPannel testPannel(frame, map, $frame.width * 0.24, $frame.height * 0.75, $frame.width * 0.75, $frame.height * 0.25)
	ConstraintBox cstr(frame, "Contrainte 1", $frame.width * 0.24, 0, "X", "Y", "Z", "Heading")
	ControlPannel ctrlPannel(frame, 0, 0, $frame.width * 0.24, $frame.height * 0.30)


	cstr.xProp =:> testPannel.link.dx
	cstr.yProp =:> testPannel.link.dy
	cstr.headingProp =:> testPannel.link.drot



	FlightPlan fpl(frame, "Leader Flight Plan", 0, $frame.height * 0.30, $frame.width * 0.24, $frame.height * 0.70)

}



