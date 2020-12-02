use core
use base
use display
use gui

import Map.models.object.MobileObject

_define_
MyPlaneLabelObject (double latitude_,double longitude_, Process map_){
	//Mobile object that represent a plane label
	map aka map_
	MobileObject mobileObject (latitude_,longitude_,map)
	longitude aka mobileObject.longitude
	latitude aka mobileObject.latitude
	futureLon aka mobileObject.futureLon
	futureLat aka mobileObject.futureLat
	Double time (0)
	Double dist (0)
	String time_unit ("") 
	String dist_unit ("")

	DoubleFormatter time_f (0,2)
	time =:> time_f.input
	DoubleFormatter dist_f (0,2)
	dist =:> dist_f.input
	Spike showEverything
	Spike showOnlyPast
	Spike showOnlyFuture
	Spike follow
	Spike unfollow
	Spike showContextualMenu
	Spike hideContextualMenu
	
	Spike press
	Int press_x (0)
	Int press_y (0)

	addChildrenTo mobileObject.gc {
		Component rect {
			OutlineWidth _ (3)
			OutlineColor _ (50,50,50)
			OutlineOpacity _ (0.8)
			FillOpacity a (0.5)
	  		FillColor fc (50, 50, 50)
			Rectangle label_rect (0,0,70,35,0,0)
		}
		Component text {
			Scaling text_scale (0.5,0.5,0,0)
			FillColor _ (255,255,255)
			OutlineColor _ (255,255,255)
			FillOpacity _ (1)
			Text dist_left (5,18,"Dist Left : ")
			"Dist Left : " + dist_f.output + " " + dist_unit =:> dist_left.text
			Text time_left (5,36,"Time Left : ")
			"Time Left : " + time_f.output + " " + time_unit =:> time_left.text
			Text right_click (5,54,"RCLICK + OPTIONS ")

		}
		FSM contextMenu {
			State notShown
			State shown{
				Component contextualMenu {
					Scaling text_scale (0.5,0.5,0,0)
					FillColor _ (50,50,50)
					Rectangle menu (45,20,80,160,0,0)
					Rectangle every (45,20,80,40,0,0)
					every.press -> showEverything,hideContextualMenu
					Rectangle past (45,20+40,80,40,0,0)
					past.press -> showOnlyPast,hideContextualMenu
					Rectangle future (45,20+80,80,40,0,0)
					future.press -> showOnlyFuture,hideContextualMenu
					Rectangle followRect (45,20+120,80,40,0,0)
					FillColor _ (255,255,255)
					Text t_every (45+30,20 + 25,"All")
					Text t_past (45+25,20+65,"Past")
					Text t_future (45+21,20+105,"Future")
					Text t_follow (45+21,20+145,"Follow")
				}
			}
			notShown -> shown (showContextualMenu)
			shown -> notShown (hideContextualMenu)
		}
	}	

	FSM followFSM {
		State notFollowing{
			"Follow" =:  mobileObject.gc.contextMenu.shown.contextualMenu.t_follow.text
			45 + 21 =: mobileObject.gc.contextMenu.shown.contextualMenu.t_follow.x
			mobileObject.gc.contextMenu.shown.contextualMenu.followRect.press -> follow,hideContextualMenu
		}
		State following{
			"Unfollow" =:  mobileObject.gc.contextMenu.shown.contextualMenu.t_follow.text
			45+12 =: mobileObject.gc.contextMenu.shown.contextualMenu.t_follow.x
			mobileObject.gc.contextMenu.shown.contextualMenu.followRect.press -> unfollow,hideContextualMenu
		}
		notFollowing -> following (follow)
		following -> notFollowing (unfollow)
	}

	FSM fsmLabel {
		State outLabel{
			// GenericMouse.left.press -> mobileObject.gc.hideContextualMenu
		}
		State inLabel{
			GenericMouse.left.press -> press
			map.frame.move -> map.pz.forceNoPan
			GenericMouse.right.press -> showContextualMenu 
			mobileObject.gc.rect.label_rect.press.x =:> press_x
			mobileObject.gc.rect.label_rect.press.y =:> press_y
		}
		outLabel -> inLabel (mobileObject.gc.rect.label_rect.enter)
		inLabel -> outLabel (mobileObject.gc.rect.label_rect.leave)
	}		

}