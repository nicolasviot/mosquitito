use core
use base
use display
use gui
use comms
import Map.widgets.Button





_define_
ControlPannel(Process frame, double _x, double _y, double _width, double _height)
{

	/* Constants */
	String takeoff_leader("ground JUMP_TO_BLOCK 21 3")
	String takeoff_follower1("ground JUMP_TO_BLOCK 22 3")
	String takeoff_follower2("ground JUMP_TO_BLOCK 23 3")
	

	String init_formation("ground JUMP_TO_BLOCK 21 5")
	String start_formation("ground JUMP_TO_BLOCK 21 8")
	String join_formation_follower1("ground JUMP_TO_BLOCK 22 9")
	String join_formation_follower2("ground JUMP_TO_BLOCK 23 9")

	//The ivy bus
	IvyAccess controlPannelBus("127.255.255.255:2010", "smala ControlPannel", "READY")

	FillColor fill(32, 32, 104)
	Rectangle bg($_x, $_y, $_width, $_height)

	Translation t($_x, $_y)


	Button but_takeoff_leader(frame, "Leader takeoff", 20, 20)
	Button but_takeoff_follower1(frame, "Follower1 takeoff", 140, 20)
	Button but_takeoff_follower2(frame, "Follower1 takeoff", 260, 20)
	Button but_init_formation_leader(frame, "Leader init formation", 20, 100)
	Button but_start_formation(frame, "Leader start_formation", 140, 100)
	Button but_join_formation_follower(frame, "Followers join_formation", 260, 100)

	but_takeoff_leader.click -> {
		this.takeoff_leader =: this.controlPannelBus.out
	}

	but_takeoff_follower1.click -> {
		this.takeoff_follower1 =: this.controlPannelBus.out
	}

	but_takeoff_follower2.click -> {
		this.takeoff_follower2 =: this.controlPannelBus.out
	}

	but_init_formation_leader.click -> {
		this.init_formation =: this.controlPannelBus.out
	}

	but_start_formation.click -> {
		this.start_formation =: this.controlPannelBus.out
	}

	but_join_formation_follower.click -> {
		this.join_formation_follower1 =: this.controlPannelBus.out
		this.join_formation_follower2 =: this.controlPannelBus.out
	}
}