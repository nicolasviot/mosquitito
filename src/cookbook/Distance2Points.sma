use core
use base
use gui

import Map.models.object.FixedPoint
import Map.utils.computation.DistanceGps
import Map.utils.computation.TravelTimeGps

_define_
Distance2Points ( Process map_){
	map aka map_
	frame aka map.frame

	Spike ctrl
	Spike ctrl_r
	frame.key\-pressed == 16777249 -> ctrl
	frame.key\-released == 16777249-> ctrl_r

	Spike shift
	Spike shift_r
	frame.key\-pressed == 16777248-> shift
	frame.key\-released == 16777248-> shift_r

	Bool correct1 (0)
	Bool correct2 (0)

	FSM markerPlacing {
		State idle 
		State ctrlK {
			frame.press ->(this){
				delete this.map.layers.p1
				addChildrenTo this.map.layers{
					FixedPoint p1 ($this.map.lati_pointed,$this.map.longi_pointed,this.map)
				}
				this.correct1 = 1
			}
			frame.move -> map.pz.forceNoPan
		}
		State shiftK {
			frame.press -> (this) {
				delete this.map.layers.p2
				addChildrenTo this.map.layers {
					FixedPoint p2 ($this.map.lati_pointed,$this.map.longi_pointed,this.map)
				}
				this.correct2 = 1
			} 
			frame.move -> map.pz.forceNoPan
		}
			
		idle -> ctrlK (ctrl)
		idle -> shiftK (shift)
		ctrlK -> idle (ctrl_r)
		shiftK -> idle (shift_r)
	}
	TextPrinter log 
	correct1 == 1 && correct2 == 1 -> (this){
		addChildrenTo this {

			//Without the third arguments gets distance in meters
			//DistanceGps distanceGps (p1,p2)

			Double speed (200)
			DoubleFormatter dbFspeed ($speed,2)
			speed => dbFspeed.input
			String speed_unit ("km/h")
			String time_unit ("h")
			//third arguments can be "m","km","nm"
			DistanceGps distanceGps (this.map.layers.p1,this.map.layers.p2, "km")
			DoubleFormatter dbFdist (0,2)
			distanceGps.output =:> dbFdist.input
			TravelTimeGps t (this.map.layers.p1,this.map.layers.p2,$speed,toString($speed_unit),toString($time_unit))
			DoubleFormatter dbFtime (0,2)
			t.output =:> dbFtime.input

			Spike n_KEY
			this.frame.key\-pressed == 78-> {"nm" =: distanceGps.unit}
			Spike k_KEY
			this.frame.key\-pressed == 75-> {"km" =: distanceGps.unit}
			Spike m_KEY
			this.frame.key\-pressed == 77-> {"m" =: distanceGps.unit}
			
			"Distance between the 2 points:  " + dbFdist.output +" " + distanceGps.unit =:>this.t3.text
			"Travel time between the 2 points at " + dbFspeed.output + " " + t.speed_unit + " :  " + dbFtime.output + " " + t.time_unit=:>this.t4.text
		}
	}
	Text t1 ($this.map.t.tx, $this.map.t.ty + $this.map.clipping.height + 600, "Press ctrl+click to place the first marker then shift+click to place the second point")
	Text t2 ($this.map.t.tx, $this.map.t.ty + $this.map.clipping.height + 625, "Press \"N \" for Nautical Miles     || Press \"K \" for Kilometers    ||Press \"M \" for Meters")
	Text t3 ($this.map.t.tx, $this.map.t.ty + $this.map.clipping.height + 650, "Distance between the 2 points:  ")
	Text t4 ($this.map.t.tx, $this.map.t.ty + $this.map.clipping.height + 675, "Travel time between the 2 points at 200 km/h :")

}