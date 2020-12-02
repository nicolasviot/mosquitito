use core
use base
use gui

//Widget to control the different action on the map
_define_
MapController (Process map){

    svg = loadFromXML ("./ressources/widget.svg")
    svgCompas = loadFromXML("./ressources/compas.svg")
    Component utilsWidget{
    	Translation t (0,0)
		map.clipping.width +map.t.tx -450 =:> t.tx
		map.clipping.height +map.t.ty - 175=:> t.ty
		Scaling scaling (0.4,0.4,0,0)
		
		Component leftArrow {
			FillOpacity a (0.25)
			FillColor fc (50,50,50)
			leftArrowSvg << svg.layerLeftArrow
			r aka leftArrowSvg.left_arrow
			FSM fsm {
			    State idle {
			      0.25 =: a.a
			      50 =: fc.r
			    }
			    State entered{
			      0.8 =: a.a
			    }
			    State pressed {
			      150 =: fc.r
			    }

			    idle->entered (r.enter)
			    entered -> idle (r.leave)
			    entered -> pressed (r.press)
			    pressed->entered (r.release,map.turnRigth)
			    pressed->idle (map.frame.release)
			}
		}

		Component rightArrow {
			FillOpacity a (0.25)
			FillColor fc (50,50,50)
			rightArrowSvg << svg.layerRightArrow
			r aka rightArrowSvg.right_arrow
			FSM fsm {
			    State idle {
			      0.25 =: a.a
			      50 =: fc.r
			    }
			    State entered{
			      0.8 =: a.a
			      50 =: fc.r
			    }
			    State pressed {
			      150 =: fc.r
			    }

			    idle->entered (r.enter)
			    entered -> idle (r.leave)
			    entered -> pressed (r.press)
			    pressed->entered (r.release,map.turnLeft)
			    pressed->idle (map.frame.release)
			}
		}

		Component plus {
			FillOpacity a (0.25)
			FillColor fc (50,50,50)
			plusSvg << svg.layerPlus
			r aka plusSvg.plus_symbol
			FSM fsm {
			    State idle {
			      0.25 =: a.a
			      50 =: fc.r
			    }
			    State entered{
			      0.8 =: a.a
			      50 =: fc.r
			    }
			    State pressed {
			      150 =: fc.r
			    }

			    idle->entered (r.enter)
			    entered -> idle (r.leave)
			    entered -> pressed (r.press)
			    pressed->entered (r.release,map.zoomInCentered)
			    pressed->idle (map.frame.release)
			}
		}

		Component minus {
			FillOpacity a (0.25)
			FillColor fc (50,50,50)
			minusSvg << svg.layerMinus
			r aka minusSvg.minus_symbol
			FSM fsm {
			    State idle {
			      0.25 =: a.a
			      50 =: fc.r
			    }
			    State entered{
			      0.8 =: a.a
			      50 =: fc.r
			    }
			    State pressed {
			      150 =: fc.r
			    }

			    idle->entered (r.enter)
			    entered -> idle (r.leave)
			    entered -> pressed (r.press)
			    pressed->entered (r.release,map.zoomOutCentered)
			    pressed->idle (map.frame.release)
			}
		}

		Component reload {
			FillOpacity a (0.25)
			FillColor fc (50,50,50)
			reloadSvg << svg.layerReload
			r aka reloadSvg.reload
			FSM fsm {
			    State idle {
			      0.25 =: a.a
			      50 =: fc.r
			    }
			    State entered{
			      0.8 =: a.a
			      50 =: fc.r
			    }
			    State pressed {
			      150 =: fc.r
			    }

			    idle->entered (r.enter)
			    entered -> idle (r.leave)
			    entered -> pressed (r.press)
			    pressed->entered (r.release,map.force_redownload)
			    pressed->idle (map.frame.release)
			}
		}
	}	

	Spike show 
	Spike hide 
	map.orientation != 0 -> show 
	map.orientation == 0 -> hide
	FSM showCompas {
		State notShown

		State shown{
			Component compas {
				
				FillOpacity a (0.7)
				FillColor fc (50,50,50)
				Translation t (0,0)
				map.t.ty - 50=:> t.ty
				map.clipping.width + map.t.tx -300 =:> t.tx
				Scaling scaling (0.4,0.4,0,0)
				Rotation rot (0,582,295)
				- map.orientation =:> rot.a
				compasSVG << svgCompas.layerCompas
				r aka compasSVG.compas
				FSM fsm {
					    State idle {
					      0.6 =: a.a
					      50 =: fc.r
					    }
					    State entered{
					      1 =: a.a
					      50 =: fc.r
					    }
					    State pressed {
					      150 =: fc.r
					    }

					    idle->entered (r.enter)
					    entered -> idle (r.leave)
					    entered -> pressed (r.press)
					    pressed->entered (r.release,map.turnNorth)
					    pressed->idle (map.frame.release)
					}
			}
		}
		notShown -> shown (show)
		shown -> notShown (hide)
	}


}