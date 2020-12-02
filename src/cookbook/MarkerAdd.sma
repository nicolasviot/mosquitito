use core
use base
use display
use gui


import Map.utils.sketching.MyCircle
import Map.utils.sketching.NewCircHandler
import Map.utils.sketching.MyRectangle
import Map.utils.sketching.NewRectHandler
import Map.models.point.PointGps
import Map.models.object.FixedPoint


_define_
MarkerAdd ( Process map_){
	//Example to show how to draw interactively things on the map 
	//Not perfect at all, it's mostly for giving idea of how to do it
	map aka map_
	frame aka map.frame
	Double startPtx(0)
	Double startPty(0)
	Double endPtx(0)
	Double endPty(0)

	Spike ctrl
	Spike ctrl_r
	frame.key\-pressed == 16777249 -> ctrl
	frame.key\-released == 16777249-> ctrl_r

	Spike shift
	Spike shift_r
	frame.key\-pressed == 16777248-> shift
	frame.key\-released == 16777248-> shift_r

	Spike space
	Spike space_r
	frame.key\-pressed == 32 -> space
	frame.key\-released == 32 -> space_r
	Ref null_ref (null)
	Spike toIdle
	FSM markerPlacing {
		State idle 
		/*State ctrlK {
			
			frame.press ->(this){
				addChildrenTo this.map.layers{
					FixedPoint p ($this.map.lati_pointed,$this.map.longi_pointed,this.map)
					178 =: p.fc.r
					34 =: p.fc.g
					34 =: p.fc.b
				}
			}
			frame.move -> map.pz.forceNoPan
		}
		*/
		State ctrlK{
			FSM drawingDots{
				State idle
				State pressed{
					frame.move -> map.pz.forceNoPan
					frame.move -> (this){
						addChildrenTo this.map.layers{
						FixedPoint p ($this.map.lati_pointed,$this.map.longi_pointed,this.map)
						178 =: p.fc.r
						34 =: p.fc.g
						34 =: p.fc.b
						}
					}
				}
				idle -> pressed (frame.press)
				pressed -> idle (frame.release) 
			}
		}
		/*
		State shiftK {
				
			frame.press -> (this) {
				addChildrenTo this.map.layers {
					MyCircle c (this.map)
					NewCircHandler handler (this.map,this.map.obj_selected)					
				}
			} 
			frame.move -> map.pz.forceNoPan
		}
		*/
		

		State shiftK {
			FSM drawingLine{
				State idle
				State pressed{
					//stocker init
					frame.move -> map.pz.forceNoPan
					this.map.pointedX =: startPtx
					this.map.pointedY =: startPty
					this.map.pointedX =: endPtx
					this.map.pointedY =: endPty
					Circle start ($startPty, $startPty, 10)

				}
				State drag {
					//preview draw endPoint + segment
					frame.move -> map.pz.forceNoPan
					this.map.pointedX =:> endPtx
					this.map.pointedY =:> endPty
					Circle start ($startPty, $startPty, 10)
					Circle end ($endPtx, $endPty, 50)
					endPtx => end.cx
					endPty => end.cy
					
					Line segment ($startPtx, $startPty, $endPtx, $endPty)

				}

			idle -> pressed (frame.press)
			pressed -> drag (frame.move)
			drag -> idle (frame.release)


			}


		}
		State spaceK {
				
			frame.press -> (this) {
				addChildrenTo this.map.layers {
					MyRectangle r (this.map)
					NewRectHandler handler (this.map,this.map.obj_selected)
				}
			} 
			frame.move -> map.pz.forceNoPan
		}
			
		

		idle -> ctrlK (ctrl)
		idle -> shiftK (shift)
		idle -> spaceK (space)
		ctrlK -> idle (ctrl_r)
		shiftK -> idle (shift_r)
		spaceK -> idle (space_r)	
	}


	Text t2 ($map.t.tx, $map.t.ty + $map.clipping.height + 600, "Press \"CTRL + CLICK\" to place marker")
	Text t3 ($map.t.tx, $map.t.ty + $map.clipping.height + 625, "Press \"SHIFT + CLICK + DRAG\" to draw a Circle")
	Text t4 ($map.t.tx, $map.t.ty + $map.clipping.height + 650, "Press \"SPACE + CLICK + DRAG\" to draw a Rectangle")
	Text t5 ($map.t.tx, $map.t.ty + $map.clipping.height + 675, "")
	"Actual coordinates of cursor: lat : " + map.lati_pointed + " , lon : " + map.longi_pointed=:>t5.text
	
}