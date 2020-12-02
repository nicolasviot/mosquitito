use core
use base
use gui
use comms


_define_
RejeuStream (Process map, Process bus, Process _flightNumber){
	//Stream which is specific to Rejeu usage
	string fn = toString(_flightNumber)
	String flightNumber (fn)
	Double latitude (-1000)
	Double longitude (-1000)
	Int heading (-1000)
	Int altitude_fl (0)
	Int altitude (-1000)
	altitude_fl*100 => altitude

	Int speed (0)

	//latitude
	Connector _ (bus, "in/^TrackMovedEvent Flight=" + fn + " CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/3", this, "latitude")
	//longitude
	Connector _ (bus, "in/^TrackMovedEvent Flight=" + fn + " CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/4", this, "longitude")
	//heading
	Connector _ (bus, "in/^TrackMovedEvent Flight=" + fn + " CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/9", this, "heading")
	//speed
	Connector _ (bus, "in/^TrackMovedEvent Flight=" + fn + " CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/10", this, "speed")
	//altitude
	Connector _ (bus, "in/^TrackMovedEvent Flight=" + fn + " CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/7", this, "altitude_fl")
	Spike end
	Spike remove_
	

	//FOR THE FUN 
	map.frame.key\-pressed == 68 -> {"AircraftTurn Flight="+fn+" Angle=10" =: bus.out}
	map.frame.key\-pressed == 81 -> {"AircraftTurn Flight="+fn+" Angle=-10" =: bus.out}
	map.frame.key\-pressed == 90 -> {"AircraftSpeed Flight="+fn+" Type=IAS Value="+to_string(speed + 20) =: bus.out}
	map.frame.key\-pressed == 83 -> {"AircraftSpeed Flight="+fn+" Type=IAS Value="+to_string(speed - 20) =: bus.out}
	Spike forwardSpike
	Spike backwardSpike

	FSM changeWay {
		State forward{
			latitude != -1000 && longitude != -1000 && heading != -1000 && altitude > 0-> end
			map.timeAcceleration < 0 -> backwardSpike
		}
		State backward{
			latitude != -1000 && longitude != -1000 && heading != -1000 && altitude > 0-> remove_
			map.timeAcceleration > 0 -> forwardSpike
		}
		forward -> backward (backwardSpike)
		backward -> forward (forwardSpike)
	}


}