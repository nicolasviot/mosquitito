use core
use base
use display
use gui


//P1 & P2 must ave longitude,latitude children
//Compute distance in meter
_define_ 
DistanceGps(Process p1_, Process p2_){

	p1 aka p1_
	p2 aka p2_
	Double longitude1 ($p1.longitude)
	p1.longitude => longitude1
	Double latitude1 ($p1.latitude)
	p1.latitude => latitude1
	Double longitude2 ($p2.longitude)
	p2.longitude => longitude2
	Double latitude2 ($p2.latitude)
	p2.latitude => latitude2
	String unit ("m")
	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	Int r_earth (6378137)


	TextComparator m_comparator ("m","")
	unit =:> m_comparator.right
	TextComparator km_comparator ("km","")
	unit =:> km_comparator.right
	TextComparator nm_comparator ("nm","")
	unit =:> nm_comparator.right
	Double output (0)

	FSM changeUnit {
		State m{
			double convert = 1
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		} 
		State km{
			double convert = 1000
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		}
		State nm{
			double convert = 1852
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		}

		m -> km (km_comparator.output.true)
		m -> nm (nm_comparator.output.true)
		km -> m (m_comparator.output.true)
		km -> nm (nm_comparator.output.true)
		nm -> m (m_comparator.output.true)
		nm -> km (km_comparator.output.true)
	}
}
//Compute the distance in the given unit
_define_ 
DistanceGps(Process p1_, Process p2_, string unit_){
	p1 aka p1_
	p2 aka p2_
	Double longitude1 ($p1.longitude)
	p1.longitude => longitude1
	Double latitude1 ($p1.latitude)
	p1.latitude => latitude1
	Double longitude2 ($p2.longitude)
	p2.longitude => longitude2
	Double latitude2 ($p2.latitude)
	p2.latitude => latitude2
	String unit (unit_)
	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	Int r_earth (6378137)


	TextComparator m_comparator ("m","")
	unit =:> m_comparator.right
	TextComparator km_comparator ("km","")
	unit =:> km_comparator.right
	TextComparator nm_comparator ("nm","")
	unit =:> nm_comparator.right
	Double output (0)

	FSM changeUnit {
		State m{
			double convert = 1
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		} 
		State km{
			double convert = 1000
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		}
		State nm{
			double convert = 1852
			r_earth*acos(sin(latitude1*deg2rad)*sin(latitude2*deg2rad) + cos(latitude1*deg2rad)*cos(latitude2*deg2rad)*cos((longitude1-longitude2)*deg2rad)) /convert =:> output
		}

		m -> km (km_comparator.output.true)
		m -> nm (nm_comparator.output.true)
		km -> m (m_comparator.output.true)
		km -> nm (nm_comparator.output.true)
		nm -> m (m_comparator.output.true)
		nm -> km (km_comparator.output.true)
	}
}