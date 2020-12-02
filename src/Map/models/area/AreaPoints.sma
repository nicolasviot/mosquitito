use core
use base
use gui

import Map.models.point.PointGps

_native_code_
%{
	#include "Map/cpp/read_csv.h"
%}

_action_
create_area(Process p)
%{
	Process *data = (Process*) get_native_user_data (p);
	Process *coords = (Process*) data->find_child("coords");
	string path = ((AbstractProperty*) data->find_child ("path"))->get_string_value();
	vector<vector<double>> res = get_path_data(path);
	for(int i = 0; i < res.size(); i ++){
		Process* lat = new DoubleProperty (coords, "_", res[i][0]);
		Process* lon = new DoubleProperty (coords, "_", res[i][1]);
	}
	Process* lat = new DoubleProperty (coords, "_", res[0][0]);
	Process* lon = new DoubleProperty (coords, "_", res[0][1]);
%}

_define_ 
AreaPoints (Process map_, string path_){
	//parse the csv file to a list of PointGps
	map aka map_
	String path (path_)
	List coords
	List points	

	NativeAsyncAction create_area_ation (create_area,this,0)
	Spike endCreation
	create_area_ation.end -> (this){
		for(int i = 0; i < $this.coords.size/2; i++){
			int firstIndex = 2*i+1
			int secondIndex = 2*(i+1)
			addChildrenTo this.points{
				PointGps _ ($this.coords.[firstIndex], $this.coords.[secondIndex],this.map)	
			}
		}
		run this.endCreation
	}

}