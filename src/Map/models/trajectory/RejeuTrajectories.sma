use core
use base
use gui
use comms

import Map.models.trajectory.TrajectorySteps
import Map.models.trajectory.DynamicJourney
import Map.models.object.MyPlaneObject
import Map.models.stream.RejeuStream

_define_
RejeuTrajectories (Process map_, string ip_address){
	//Specific case of the trajectory coming from rejeu on ivybus
	map aka map_

	IvyAccess ivybus (ip_address, "Rejeu Trajectories", "READY")
	String test ("test")
	Component flightsList{
		RejeuStream _ (map,ivybus,test)
	} 

	Finder finder (flightsList, "flightNumber")
	Connector _(ivybus, "in/^TrackMovedEvent Flight=(.*) CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/1", finder, "key")
	finder.notFound-> (this) {
		addChildrenTo this.flightsList {
		  RejeuStream stream (this.map,this.ivybus,this.finder.key)
		}
		addChildrenTo this.map.layers{
			TrajectorySteps trajectorySteps (this.map)
			MyPlaneObject myPlaneObject (0,0,this.map)
		  	DynamicJourney dynaTraj (this.map, this.flightsList.stream, trajectorySteps,myPlaneObject)
		}
	}

	map.paused.false -> {"ClockStart" =: ivybus.out}
	map.paused.true -> {"ClockStop" =: ivybus.out}
	String rate ("")
	DoubleFormatter dbF (0,1)
	map.timeAcceleration =:> dbF.input
	"SetClock Rate="+dbF.output =:> rate
	rate =:> ivybus.out

}

_define_
RejeuTrajectories (Process map_, string ip_address, int x_, int y_, int width_, int height_){
	map aka map_
	Int x (x_)
	Int y (y_)
	Int width (width_)
	Int height (height_)
	IvyAccess ivybus (ip_address, "Rejeu Trajectories", "READY")
	String test ("test")
	Component flightsList{
		RejeuStream _ (map,ivybus,test)
	} 

	Finder finder (flightsList, "flightNumber")
	Connector _(ivybus, "in/^TrackMovedEvent Flight=(.*) CallSign=(.*) Ssr=(.*) Sector.*Lat=(.*) Lon=(.*) Vx=(.*) Vy=(.*) Afl=(.*) Rate=(.*) Heading=(.*) GroundSpeed=(.*) Tendency=(.*) Time/1", finder, "key")
	finder.notFound-> (this) {
		addChildrenTo this.flightsList {
		  RejeuStream stream (this.map,this.ivybus,this.finder.key)
		}
		addChildrenTo this.map.layers{
			TrajectorySteps trajectorySteps (this.map)
			MyPlaneObject myPlaneObject (0,0,this.map)
		  	DynamicJourney dynaTraj (this.map, this.flightsList.stream, trajectorySteps,myPlaneObject, $this.x,$this.y,$this.width,$this.height)
		  	myPlaneObject.press -> dynaTraj.showProfile
		  	myPlaneObject.unselect -> dynaTraj.hideProfile
		  	run dynaTraj.hideProfile
		}
	}

	map.paused.false -> {"ClockStart" =: ivybus.out}
	map.paused.true -> {"ClockStop" =: ivybus.out}
	String rate ("")
	DoubleFormatter dbF (0,1)
	map.timeAcceleration =:> dbF.input
	"SetClock Rate="+dbF.output =:> rate
	rate =:> ivybus.out

}