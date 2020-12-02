use core
use base
use display
use gui

import Map.kernel.Tile
import Map.kernel.PanAndZoom
import Map.utils.conversion.Screen2Gps
import Map.utils.conversion.Gps2Screen


_native_code_
%{
	#include "Map/cpp/map_.h"
%}



_define_
Map(Process frame_, string tileSource_,int zoom_, double latitude_, double longitude_, int orientation_,int x_, int y_, int width_, int height_){
	//components if you want to add something linked to the map but without been hide by the rectangle clip
	Component otherComponents {
		
	}

	//place the map at the given coordinates
	Translation t (x_, y_)

	//RectangleClip that show only the wanted tiles (allow to load map in advance)
	RectangleClip clipping (0, 0, 0, 0)
	0 =: clipping.x
	0 =: clipping.y
	height_ + 0 =: clipping.height
	width_ + 0=: clipping.width
	(frame_.width> width_) ? width_ : frame_.width - t.tx =:> clipping.width
	(frame_.height> height_) ? height_ : frame_.height -t.ty =:> clipping.height
	Spike press

	//alias of variables in order to download tiles asynchronously
	Int zoom (zoom_) 
	Double longitude (longitude_)
	Double latitude (latitude_) 
	frame aka frame_
	Int width (width_)
	Int height (height_)
	AdderAccumulator acc_orient (orientation_,-360,360)
	orientation aka acc_orient.result
	Double new_latitude (0)
	Double new_longitude (0)

	Ref obj_selected (null)
	Ref stream_active (null)
	Ref profile_ref (null)
	Ref null_ref (null)
	
	Int row (height_/256 + 5)
	Int column (width_/256 + 4)
	
	//Data used for download and coordinates calculus
	String tileSource (tileSource_)
	String topLeftpath ("")
	String pointed_path ("")
	Int num_tile (0)
	Int pan_direction (0)
	Double longi_pointed (0)
	Screen2Gps screen2Gps_pointed (this)
	screen2Gps_pointed.outputLon => longi_pointed 
	Double lati_pointed (0)
	screen2Gps_pointed.outputLat => lati_pointed
	Int originX (0)
	Int originY (0)
	Int pointedX (0)
	Int pointedY (0)
	Double timeAcceleration (1)
	Bool paused (0)

	//get the tiles number to display
	Int firstXtile (begin_x(zoom, longitude,width_/256 + 4))
	Int lastXtile (end_x(zoom, longitude,width_/256 + 4))
	Int firstYtile (begin_y(zoom, latitude,height_/256 + 5))
	Int lastYtile (end_y(zoom,latitude,height_/256 + 5))
	
	Spike redraw
	Spike zoomInCentered
	Spike zoomOutCentered
	Spike zoomInCursor
	Spike zoomOutCursor
	Spike changeLocation
	//Set an Homography to the following components
	Homography panAndZoomTransform
	//list of tiles that is the core of the map
	List tiles {
		int k = 1
		for(int i = $firstXtile; i <= $lastXtile; i++){
			int x_index = mod_func(i,pow(2,$zoom))
			for (int j = $firstYtile; j <= $lastYtile; j++){
				Tile t (this,frame,format_cache(zoom,x_index,j,toString(tileSource)), 256*(i-firstXtile-1),256*(j-firstYtile-1),256, k)
				k++
			}
		}
	}
	
	tiles.[1].path =: topLeftpath
	tiles.[1].x =: originX
	tiles.[1].y =: originY

	// Re-anchor the tiles in order to be centered on the lat/lon
	Gps2Screen gps2Screen (this)
	longitude =:> gps2Screen.inputLon
	latitude =:> gps2Screen.inputLat
	AdderAccumulator  anchorX_acc (0,0,0)
	AdderAccumulator anchorY_acc (0,0,0)
	Double anchX (0)
	anchorX_acc.result ::> anchX
	Double anchY (0)
	anchorY_acc.result ::> anchY
	TextPrinter log 
	FSM reanchorFsm {
		State reanchor {
			-anchX + clipping.width/2 - gps2Screen.outputX => panAndZoomTransform.rightTranslateBy.dx,anchorX_acc.input
			-anchY + clipping.height/2 - gps2Screen.outputY => panAndZoomTransform.rightTranslateBy.dy,anchorY_acc.input
		}
		State idle 

		reanchor -> idle (anchorY_acc.input)
		idle -> reanchor (zoom)
		idle -> reanchor (changeLocation)
	}

	//Component where you can add whatever object and it will follow the panning of the map
	Component layers {
		
	}

	// trigger to unzoom to normal before rendering new tiles 
	//(case zoom : go back to normal zoom / case unzoom : zoom 3 times to get the 3rd zoom level)
	Spike unzoom_to_normal
	Spike zoom_to_normal

	zoom_to_normal -> pointedX,pointedY,lati_pointed,longi_pointed
	unzoom_to_normal -> pointedX,pointedY,lati_pointed,longi_pointed

	//Initiate the PanAndZoom action to the map 
  	PanAndZoom pz (frame, this, panAndZoomTransform)

	
	
	//Spike to trigger the redownload of each visible tiles
	Spike force_redownload  	

  	redraw -> (this){
  		for(int i = 1; i <= $this.tiles.size; i++ ){
  			this.tiles.[i].img.path = toString(this.tiles.[i].path) 
  		}
  	}

  	force_redownload -> (this){
  		for(int i = 1; i <= $this.tiles.size; i++ ){
  			run this.tiles.[i].redownload
  		}
  	}

  	Spike accelerateTime

  	Spike decelerateTime

  	AssignmentSequence timeAccelerationUp (1){
  		(timeAcceleration != -1)?timeAcceleration + 1 : 1 =: timeAcceleration
  	}
   	AssignmentSequence timeAccelerationDown (1){
  		(timeAcceleration != 1)?timeAcceleration - 1 : -1 =: timeAcceleration	
  	}

  	accelerateTime -> timeAccelerationUp
  	decelerateTime -> timeAccelerationDown

  	Spike turnRigth
  	Spike turnLeft
  	Spike turnNorth
  	turnRigth -> {5 =: acc_orient.input}
  	turnLeft -> {-5 =: acc_orient.input}
  	turnNorth -> {0 =: acc_orient.result }
  	acc_orient.result == 360 || acc_orient.result == -360 -> {0 =: acc_orient.result}

  	AssignmentSequence changeLocSeq (1){
  		new_latitude =: latitude
  		new_longitude =: longitude
  	}
  	new_latitude ->changeLocSeq, changeLocation
  	new_longitude ->changeLocSeq, changeLocation

  	Spike nextStep
  	Spike previousStep

  	Int seconds (0)
  	Clock clock (1000)
  	1/abs(timeAcceleration)*(1000)=:> clock.period
  	paused.true ->! clock
	paused.false -> clock
	Spike forwardSpike
	Spike backwardSpike
	FSM changeWay {
		State forward{
			clock.tick -> {seconds + 1 =: seconds}
			timeAcceleration < 0 -> backwardSpike
		}
		State backward{
			clock.tick -> {(seconds>1)?seconds - 1: 0 =: seconds}
			timeAcceleration > 0 -> forwardSpike
		}
		forward -> backward (backwardSpike)
		backward -> forward (forwardSpike)
	}
  	
}
