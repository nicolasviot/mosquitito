use core
use base
use gui

import Map.models.trajectory.RejeuTrajectories

_define_
ExempleRejeu (Process map_){
	//Example to show how to use rejeu with the map
	map aka map_
	//Launch Rejeu with : ./rejeu -b 224.255.255.255:2010 trafic.txt -s auto -n
	RejeuTrajectories rejeuTrajectories (map,"224.255.255.255:2010")
	//If you want to have the profile of each aircraft
	// RejeuTrajectories rejeuTrajectories (map,"224.255.255.255:2010",1200,10,450,450)

	
}