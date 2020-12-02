use core
use base
use display
use gui

_native_code_
%{
	#include "Map/cpp/download.h"
%}


_action_
download_action(Process p )
%{
	Process *data = (Process*) get_native_user_data (p);

    string path = ((AbstractProperty*) data->find_child ("path"))->get_string_value();

    download(path);
%}

_action_
delete_action(Process p )
%{
	Process *data = (Process*) get_native_user_data (p);

    string path = ((AbstractProperty*) data->find_child ("path"))->get_string_value();

    delete_image(path);
%}


_define_ 
Tile(Process map,Process frame,  string path_, int x_, int y_, int dimension, int num_tile){
	Translation t (x_, y_)
	x aka t.tx
	y aka t.ty

	NativeAsyncAction tile_download (download_action,this, 0)
	NativeAsyncAction tile_deletion (delete_action,this, 1)

	//Spike in order to force supression and redownload of tile
	Spike redownload 

	Int num_tileT (num_tile)
	String path ("")
	toString(path_) =: path
	Rectangle localRef (0,0, 0,0,0,0)
	Image img ("", 0, 0, dimension, dimension)
	path =:> img.path
	ScreenToLocal s2l (localRef)
	FSM fsm_tile_detection {
		State out{
		} 

		State entered {
			img.path =: map.pointed_path
			num_tileT =: map.num_tile
			img.move.x =:> s2l.inX
			img.move.y =:> s2l.inY
			s2l.outX =:> map.screen2Gps_pointed.inputX
			s2l.outY =:> map.screen2Gps_pointed.inputY
			img.move.x - map.t.tx=:> map.pointedX
			img.move.y - map.t.ty=:> map.pointedY
			GenericMouse.left.press -> map.press
		}

		out -> entered (img.enter)
		entered -> out (img.leave)
		// entered -> out (map.clipping.leave)
	}

	path -> tile_download
	tile_download.end -> map.redraw

	redownload -> tile_deletion
	tile_deletion.end -> tile_download
		
}