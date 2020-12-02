use core
use base
use display
use gui


import Map.utils.computation.DistanceGps


//P1 & P2 must ave longitude,latitude children
//Compute tavel time in the unit given for time
//speed_unit ("m/s","km/h","kts")
//time_unit ("s","m","h")
_define_ 
TravelTimeGps(Process p1_, Process p2_,  double speed_, string speed_unit_, string time_unit_){

	p1 aka p1_
	p2 aka p2_
	Double speed (speed_)
	Double speed_normalize ($speed_)
	String speed_unit (speed_unit_)
	String time_unit (time_unit_)

	DistanceGps distCalc (p1,p2)
	Double distance ($distCalc.output)
	distCalc.output =:> distance
	Double output (0)


	TextComparator ms_comparator ("m/s","")
	speed_unit =:> ms_comparator.right
	TextComparator kmh_comparator ("km/h","")
	speed_unit =:> kmh_comparator.right
	TextComparator kts_comparator ("kts","")
	speed_unit =:> kts_comparator.right

	TextComparator s_comparator ("s","")
	time_unit =:> s_comparator.right
	TextComparator m_comparator ("m","")
	time_unit =:> m_comparator.right
	TextComparator h_comparator ("h","")
	time_unit =:> h_comparator.right

	FSM changeSpeedUnit {
		State m_s{
			speed =:> speed_normalize  
		} 
		State km_h{
			speed/3.6 =:> speed_normalize
		}
		State kts{
			speed*1.852/3.6 =:> speed_normalize
		}

		m_s -> km_h (kmh_comparator.output.true)
		m_s -> kts (kts_comparator.output.true)
		km_h -> m_s (ms_comparator.output.true)
		km_h -> kts (kts_comparator.output.true)
		kts -> m_s (ms_comparator.output.true)
		kts -> km_h (kmh_comparator.output.true)
	}

	FSM changeTimeUnit {
		State s{
			distance/speed_normalize =:> output 
		} 
		State m{
			distance/(speed_normalize*60) =:> output 
		}
		State h{
			distance/(speed_normalize*3600) =:> output 
		}

		s -> m (m_comparator.output.true)
		s -> h (h_comparator.output.true)
		m -> s (s_comparator.output.true)
		m -> h (h_comparator.output.true)
		h -> s (s_comparator.output.true)
		h -> m (m_comparator.output.true)
	}
}