use core
use base
use gui

import Map.models.point.PointGps


_native_code_
%{
	#include "Map/cpp/read_csv.h"
	#include <cmath>
%}

_action_
read(Process p)
%{
	Process *data = (Process*) get_native_user_data (p);
	string path = ((AbstractProperty*) data->find_child ("path"))->get_string_value();
	int index = ((IntProperty*) data->find_child ("index"))->get_value ();
	vector<double> res = get_path_data_by_line(path,index);
	((DoubleProperty*) data->find_child ("latitude"))->set_value (res[0],1);
	((DoubleProperty*) data->find_child ("longitude"))->set_value (res[1],1);
	((DoubleProperty*) data->find_child ("altitude"))->set_value (res[2],1);
%}

_define_
SimuStream (Process map, string path_, int delay){
	//Stream that read a file line by line each "delay" milliseconds
	Int index (0)
	String path (path_)
	Double latitude (0)
	Double longitude (0)
	Int heading (0)
	Int altitude (0)
	NativeAction na (read,this,0)
	Clock clock (delay)
	1/abs(map.timeAcceleration)*(delay)=:> clock.period
	Spike end
	Spike remove_
	Spike eof
	Spike forwardSpike
	Spike backwardSpike

	AssignmentSequence incrIndex (1){
		index + 1 =: index
	}
	AssignmentSequence decrIndex (1){
		(index>1)? index - 1 : 0=: index
	}
	FSM changeWay {
		State forward{
			clock.tick-> na,incrIndex
			latitude != 0 || longitude != 0 -> end
			longitude == 0 && latitude == 0 -> eof
			map.timeAcceleration < 0 -> backwardSpike
		}
		State backward{
			clock.tick-> na,decrIndex
			latitude != 0 || longitude != 0 -> remove_
			map.timeAcceleration > 0 -> forwardSpike
		}
		State notOk{
			stop clock
		}

		forward -> backward (backwardSpike)
		backward -> forward (forwardSpike)
		forward-> notOk (eof)
	}
	map.paused.true ->! clock
	map.paused.false -> clock
}