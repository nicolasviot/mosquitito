use core
use base
use display
use gui
use comms
import Map.widgets.Button
import Map.widgets.ConstraintBox


_define_
ControlPannel(Process frame, double _x, double _y, double _width, double _height, Process controlPannelBus)
{

	/* Constants */
	String takeoff_leader("ground JUMP_TO_BLOCK 21 3")
	String takeoff_follower1("ground JUMP_TO_BLOCK 22 3")
	String takeoff_follower2("ground JUMP_TO_BLOCK 23 3")
	
	String init_formationL("ground JUMP_TO_BLOCK 21 5")
	String init_formationF1("ground JUMP_TO_BLOCK 22 5")
	String init_formationF2("ground JUMP_TO_BLOCK 22 5")

	String join_formationF1("ground JUMP_TO_BLOCK 22 9")
	String join_formationF2("ground JUMP_TO_BLOCK 23 9")

	String stdbyF1("ground JUMP_TO_BLOCK 22 7")
	String stdbyF2("ground JUMP_TO_BLOCK 23 8")

	String start_formation("ground JUMP_TO_BLOCK 21 8")
	String stop_formation("ground JUMP_TO_BLOCK 21 10")


	/*
# In :
# FP_REQ fp_path / sends all fp_info, waypoints, sectors, exceptions, blocks - one message for each
# FP_INFO_REQ fp_path / sends fp_info - one message
# FP_WPS_REQ / sends all waypoints - one message for each
# FP_SECTORS_REQ / sends all sectors - one message for each
# FP_EXCEPTIONS_REQ / sends all expcetions - one message for each
# FP_BLOCKS_REQ / sends all blocks - one message for each

	*/
	String PATH_LEADER("file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String PATH_LEADER("file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String PATH_LEADER("file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")

	String FP_REQ_LEADER("FP_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String FP_REQ_F1("FP_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_REQ_F2("FP_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")

	String FP_INFO_REQ_LEADER("FP_INFO_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml") 
	String FP_INFO_REQ_F1("FP_INFO_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_INFO_REQ_F2("FP_INFO_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")

	String FP_WPS_REQ_LEADER("FP_WPS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String FP_WPS_REQ_F1("FP_WPS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_WPS_REQ_F2("FP_WPS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")
	
	String FP_SECTORS_REQ_LEADER("FP_SECTORS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String FP_SECTORS_REQ_F1("FP_SECTORS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_SECTORS_REQ_F2("FP_SECTORS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")

	String FP_EXCEPTIONS_REQ_LEADER("FP_EXCEPTIONS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String FP_EXCEPTIONS_REQ_F1("FP_SECTORS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_EXCEPTIONS_REQ_F2("FP_SECTORS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")

	String FP_BLOCKS_REQ_LEADER("FP_BLOCKS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_leader/flight_plan.xml")
	String FP_BLOCKS_REQ_F1("FP_BLOCKS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_1/flight_plan.xml")
	String FP_BLOCKS_REQ_F2("FP_BLOCKS_REQ file:///home/ubuntu/paparazzi/var/aircrafts/Microjet_follower_2/flight_plan.xml")



	Double Xl(0)
	Double Yl(0)
	Double Xf1(0)
	Double Yf1(0)
	Double Xf2(0)
	Double Yf2(0)
	Double modeL(0)
	Double modeF1(0)
	Double modeF2(0)
	DoubleFormatter modeL_df (0, 0)
	DoubleFormatter modeF1_df (0, 0)
	DoubleFormatter modeF2_df (0, 0)
	modeL => modeL_df.input
	modeF1 => modeF1_df.input
	modeF2 => modeF2_df.input

	//IvyAccess controlPannelBus("127.255.255.255:2010", "smala ControlPannel", "READY")

	"21 FORMATION_SLOT_TM 21 " + toString(modeL_df.output) + " " + toString(Xl) + " " + toString(Yl) + " 0" => controlPannelBus.out
	"22 FORMATION_SLOT_TM 22 " + toString(modeF1_df.output) + " " + toString(Xf1) + " " + toString(Yf1) + " 0"=> controlPannelBus.out
 	"23 FORMATION_SLOT_TM 23 " + toString(modeF2_df.output) + " " + toString(Xf2) + " " + toString(Yf2) + " 0"=> controlPannelBus.out

	FillColor fill(32, 32, 104)
	Rectangle bg($_x, $_y, $_width, $_height)

	Translation t($_x, $_y)

	Spike initFormationSpike
	Spike formationON1
	Spike formationOFF1
	Spike formationON2
	Spike formationOFF2

	Spike gotoblock1_drone1
	Spike gotoblock2_drone1
	Spike gotoblock3_drone1

	Spike gotoblock1_drone2
	Spike gotoblock2_drone2
	Spike gotoblock3_drone2

	Spike gotoblock1_drone3
	Spike gotoblock2_drone3
	Spike gotoblock3_drone3

	LogPrinter logger ("source : ")
	
	gotoblock1_drone1 -> {
		"block 1 drone 1" =: logger.input

	}

	gotoblock2_drone1 -> {
		"block 2 drone 1" =: logger.input
	}

	gotoblock3_drone1 -> {
		"block 3 drone 1" =: logger.input
	}

	gotoblock1_drone2 -> {
		"block 1 drone 2" =: logger.input
	}

	gotoblock2_drone2 -> {
		"block 2 drone 2" =: logger.input
	}

	gotoblock3_drone2 -> {
		"block 3 drone 2" =: logger.input
	}

	gotoblock1_drone3 -> {
		"block 1 drone 3" =: logger.input
	}

	gotoblock2_drone3 -> {
		"block 2 drone 3" =: logger.input
	}

	gotoblock3_drone3 -> {
		"block 3 drone 3" =: logger.input
	}


	Spike abortMission
/*
	Button but_takeoff_leader(frame, "Leader takeoff", 20, 20)
	Button but_takeoff_follower1(frame, "Follower1 takeoff", 140, 20)
	Button but_takeoff_follower2(frame, "Follower1 takeoff", 260, 20)
	Button but_init_formation(frame, "Leader init formation", 20, 100)
	Button but_start_formation(frame, "Leader start_formation", 140, 100)
	Button but_join_formation_follower(frame, "Followers join_formation", 260, 100)
	Button but_stop_formation(frame, "stop formation", 20, 200)
	
	but_init_formation.click -> {
		this.init_formationL =: this.controlPannelBus.out
		this.init_formationF1 =: this.controlPannelBus.out
		this.init_formationF2 =: this.controlPannelBus.out
	}

	formationON1 -> {
		this.init_formationL =: this.controlPannelBus.out
		this.init_formationF1 =: this.controlPannelBus.out
		this.join_formationF1 =: this.controlPannelBus.out
	}

	formationON2 -> {
		this.init_formationL =: this.controlPannelBus.out
		this.init_formationF2 =: this.controlPannelBus.out
		this.join_formationF2 =: this.controlPannelBus.out
	}

	formationOFF1 -> {
		this.stop_formation =: this.controlPannelBus.out
		this.stdbyF1 =: this.controlPannelBus.out
	}

	formationOFF2 -> {
		this.stop_formation =: this.controlPannelBus.out
		this.stdbyF2 =: this.controlPannelBus.out
	}

	but_takeoff_leader.click -> {
		this.takeoff_leader =: this.controlPannelBus.out
	}

	but_takeoff_follower1.click -> {
		this.takeoff_follower1 =: this.controlPannelBus.out
	}

	but_takeoff_follower2.click -> {
		this.takeoff_follower2 =: this.controlPannelBus.out
	}

	but_start_formation.click -> {
		this.start_formation =: this.controlPannelBus.out
	}

	but_join_formation_follower.click -> {
		this.join_formationF1 =: this.controlPannelBus.out
		this.join_formationF2 =: this.controlPannelBus.out
	}
	
	but_stop_formation.click -> {
		this.stop_formation =: this.controlPannelBus.out
	}
*/
}
