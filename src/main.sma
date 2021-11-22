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

import Map.widgets.Button
import Map.widgets.ConstraintBox
import Map.widgets.FlightPlan
import Map.widgets.ControlPannel
import Map.widgets.GridPannel
import Map.widgets.MapVoliere
import Map.Communications.IvyComms
import Map.widgets.DronePatatoidal
import testPannel.TestPannel
import map_mathieu.Map

_main_
Component root {
	Frame frame ("Drone Formation Editor", 0, 0, 1920, 1080)
	//Enable mouseTracking
	mouseTracking =1
	Exit ex (0,1)
	frame.close->ex	
	IvyComms bus("Mosquitito")
	_DEBUG_GRAPH_CYCLE_DETECT = 1


	FillColor light_grey (48, 48, 48)

	Rectangle bg_constraint(0, 0, $frame.width * 0.24, $frame.height * 1 )
	Button constraint_widgets_button (frame, "constraint pannel", $frame.width * 0.12, $frame.height * 0.05)
	Button block_widgets_button (frame, "block pannel", $frame.width * 0.03, $frame.height * 0.05)

	Button test_info(frame,"test_info_ivy", $frame.width * 0.12, $frame.height * 0.025)
	Button test_blocks(frame, "test_blocks_ivy", $frame.width * 0.03, $frame.height * 0.025)



	constraint_widgets_button.click -> (root){
		//"constraint_widgets" =: root.leftPannel.state
		root.leftPannel.state = "constraint_widgets"
	} 
	block_widgets_button.click -> (root){
		//"block_widgets" =: root.leftPannel.state
		root.leftPannel.state = "block_widgets"
	}
	TestPannel testPannel(frame, $frame.width * 0.24, $frame.height, $frame.width * 0.75, $frame.height * 0.25, bus.bus)
	ControlPannel ctrlPannel(frame, 0, 0, $frame.width * 0.24, 0, bus.bus)
	ctrlPannel.FP_REQ_LEADER =: bus.bus.out
							
	/***************************************/
	/***********   Carte   *****************/ 
	/***************************************/
	

	Map map (frame, $frame.width * 0.24, 0, 1000, 800, 43.4818, 0, 8)
  	frame.{width,height} =:> map.{width,height}



	Switch leftPannel(constraint_widgets){
		Component constraint_widgets{
				//Translation _t (0, $frame.height * 0.10)
				ConstraintBox cstr(frame, "Contrainte 1", $frame.width * 0.015, $frame.height * 0.10, "X", "Y", "Z", "Heading")
				ConstraintBox cstr2(frame, "Contrainte 2", $frame.width * 0.015,  $frame.height * 0.30, "X", "Y", "Z", "Heading")
				GridPannel gridPannel(frame, $frame.width * 0.015, $frame.height * 0.60, bus.bus)
				Button switch_button (frame, "global mode", $frame.width * 0.100, $frame.height * 0.50)
		
		}


		Component block_widgets {


			Translation _t (0, $frame.height * 0.10)
			


			TextAnchor _(1)
			FillColor rec_bg (120, 120, 120)
			/*Name + description? blocks*/
			Rectangle name_bg_1 ($frame.width * 0.02, 0, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle name_bg_2 ($frame.width * 0.09, 0, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle name_bg_3 ($frame.width * 0.16, 0, $frame.width * 0.06, $frame.height * 0.10)
			



			/*Blocks*/
			Rectangle bloc_1_drone_1 ($frame.width * 0.02, $frame.height * 0.12, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_2_drone_1 ($frame.width * 0.02, $frame.height * 0.24, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_3_drone_1 ($frame.width * 0.02, $frame.height * 0.36, $frame.width * 0.06, $frame.height * 0.10)

			Rectangle bloc_1_drone_2 ($frame.width * 0.09, $frame.height * 0.12, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_2_drone_2 ($frame.width * 0.09, $frame.height * 0.24, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_3_drone_2 ($frame.width * 0.09, $frame.height * 0.36, $frame.width * 0.06, $frame.height * 0.10)

			Rectangle bloc_1_drone_3 ($frame.width * 0.16, $frame.height * 0.12, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_2_drone_3 ($frame.width * 0.16, $frame.height * 0.24, $frame.width * 0.06, $frame.height * 0.10)
			Rectangle bloc_3_drone_3 ($frame.width * 0.16, $frame.height * 0.36, $frame.width * 0.06, $frame.height * 0.10)


			FillColor text_fc (64, 64, 64)
			Text tagDrone1($frame.width * 0.05, $frame.height * 0.05, "Drone 1")
			Text tagDrone2($frame.width * 0.12, $frame.height * 0.05, "Drone 2")
			Text tagDrone3($frame.width * 0.19, $frame.height * 0.05, "Drone 3")

			Text tagDrone1_block1($frame.width * 0.05, $frame.height * 0.17, "drone1block1")
			Text tagDrone2_block1($frame.width * 0.12, $frame.height * 0.17, "drone2block1")
			Text tagDrone3_block1($frame.width * 0.19, $frame.height * 0.17, "drone3block1")

			Text tagDrone1_block2($frame.width * 0.05, $frame.height * 0.29, "drone1block2")
			Text tagDrone2_block2($frame.width * 0.12, $frame.height * 0.29, "drone2block2")
			Text tagDrone3_block2($frame.width * 0.19, $frame.height * 0.29, "drone3block2")

			Text tagDrone1_block3($frame.width * 0.05, $frame.height * 0.41, "drone1block3")
			Text tagDrone2_block3($frame.width * 0.12, $frame.height * 0.41, "drone2block3")
			Text tagDrone3_block3($frame.width * 0.19, $frame.height * 0.41, "drone3block3")

		
			/*ivy bindings*/
			/*TODO : identify relevant block ID after final flight plan version*/

			bloc_1_drone_1.press -> ctrlPannel.gotoblock1_drone1
			bloc_2_drone_1.press -> ctrlPannel.gotoblock2_drone1
			bloc_3_drone_1.press -> ctrlPannel.gotoblock3_drone1

			bloc_1_drone_2.press -> ctrlPannel.gotoblock1_drone2
			bloc_2_drone_2.press -> ctrlPannel.gotoblock2_drone2
			bloc_3_drone_2.press -> ctrlPannel.gotoblock3_drone2

			bloc_1_drone_3.press -> ctrlPannel.gotoblock1_drone3
			bloc_2_drone_3.press -> ctrlPannel.gotoblock2_drone3
			bloc_3_drone_3.press -> ctrlPannel.gotoblock3_drone3


			/*TODO : drag & drop area from block*/
			/*FSM place_area{
				State idle 
				State dragging{
					AreaRep arearep (...)

				}
				idle -> dragging(block.press)
				dragging-> idle (frame.release, generateAreaRep)
			}
*/



		}
	}


	//MapVoliere mapvoliere(frame, 50, 900, 200, 200)
	


	60 =: leftPannel.constraint_widgets.cstr.xProp
	-60 =: leftPannel.constraint_widgets.cstr.yProp
	-60 =: leftPannel.constraint_widgets.cstr2.xProp 
	-60 =: leftPannel.constraint_widgets.cstr2.yProp
	leftPannel.constraint_widgets.cstr.xProp => ctrlPannel.Xf1
	leftPannel.constraint_widgets.cstr.yProp => ctrlPannel.Yf1
	leftPannel.constraint_widgets.cstr2.xProp => ctrlPannel.Xf2
	leftPannel.constraint_widgets.cstr2.yProp	=> ctrlPannel.Yf2
	leftPannel.constraint_widgets.cstr.onSpike -> ctrlPannel.formationON1
	leftPannel.constraint_widgets.cstr.offSpike -> ctrlPannel.formationOFF1
	leftPannel.constraint_widgets.cstr2.onSpike -> ctrlPannel.formationON2
	leftPannel.constraint_widgets.cstr2.offSpike -> ctrlPannel.formationOFF2
	

	//switch formation mode from 0 (global) to 1 (local)
	leftPannel.constraint_widgets.switch_button.click ->{
	ctrlPannel.modeL?"global mode":"local mode" =: leftPannel.constraint_widgets.switch_button.thisLabel.text

	ctrlPannel.modeL?0:1 =: ctrlPannel.modeL
 	ctrlPannel.modeF1?0:1 =: ctrlPannel.modeF1
	ctrlPannel.modeF2?0:1 =: ctrlPannel.modeF2

	}

	LogPrinter log("debug : ")
	FSM pseudoBidirectionnal {
		State idle{

			leftPannel.constraint_widgets.cstr.xProp =:> leftPannel.constraint_widgets.gridPannel.link1.dx
			leftPannel.constraint_widgets.cstr.yProp =:> leftPannel.constraint_widgets.gridPannel.link1.dy
			leftPannel.constraint_widgets.cstr.headingProp =:> leftPannel.constraint_widgets.gridPannel.link1.drot

			leftPannel.constraint_widgets.cstr2.xProp =:> leftPannel.constraint_widgets.gridPannel.link2.dx
			leftPannel.constraint_widgets.cstr2.yProp =:> leftPannel.constraint_widgets.gridPannel.link2.dy
			leftPannel.constraint_widgets.cstr2.headingProp =:> leftPannel.constraint_widgets.gridPannel.link2.drot


		}

		State notidle{

			"entering grid to cstr" =: log.input

			leftPannel.constraint_widgets.gridPannel.link1.dx =:> leftPannel.constraint_widgets.cstr.xProp
			leftPannel.constraint_widgets.gridPannel.link1.dy =:> leftPannel.constraint_widgets.cstr.yProp

			leftPannel.constraint_widgets.gridPannel.link2.dx =:> leftPannel.constraint_widgets.cstr2.xProp  
			leftPannel.constraint_widgets.gridPannel.link2.dy =:> leftPannel.constraint_widgets.cstr2.yProp
			
 


		}

		idle -> notidle (leftPannel.constraint_widgets.gridPannel.bg.move)
		notidle -> idle (leftPannel.constraint_widgets.cstr.background.bg.move)
		notidle -> idle (leftPannel.constraint_widgets.cstr2.background.bg.move)

	}

}



