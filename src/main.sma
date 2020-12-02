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


import Map.Map
import Map.widgets.MapController
import testPannel.TestPannel
import Map.models.object.MobileObject
import Map.widgets.Button
import cookbook.MarkerAdd

_main_
Component root {
	Frame frame ("Constraint Editor", 0, 0,1200,800)
	//Enable mouseTracking
	mouseTracking =1
	Exit ex (0,1)
	frame.close->ex	
	//Simple map component (upper right)
	Map map(frame,"FR", 16, 43.44918, 1.263429, 0, $frame.width * 0.25, 0, $frame.width * 0.75, $frame.height * 0.75) 
	frame.width * 0.25 => map.t.tx
	MapController mapController (map)
	MarkerAdd markerAdd (map)
	Button but (frame, "test ajout in main", 50, 50)
	but.click -> (root){
		addChildrenTo root.map.layers {
			MobileObject m (43.45, 1.263429, root.map)
		}
		addChildrenTo root.map.layers.m.gc {
			FillColor bg (0, 0, 255)
			Circle form (0,0,60)
		}
	}

	//Reader Component
	//Test pannel
	
	TestPannel testPannel(frame, map, $frame.width * 0.25, $frame.height * 0.75, $frame.width * 0.75, $frame.height * 0.25)
}



