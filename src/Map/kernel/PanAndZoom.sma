use core
use base
use display
use gui

_native_code_
%{
  #include "Map/cpp/tile2coords.h"
  #include "Map/cpp/map_.h"
%}



_define_
PanAndZoom (Process frame, Process bg, Process transforms) {

//alias 
map aka bg

// Non visual rectangle serving as a local coordinates system
Rectangle localRef (0, 0, 0, 0, 0, 0)

// Store pointer position in localRef coordinates system
// (used by both zoom and pan management)
ScreenToLocal s2l (localRef)
frame.move.x =:> s2l.inX
frame.move.y =:> s2l.inY

// Rotation management
-map.orientation - transforms.acca =:> transforms.rightRotateBy.da
map.gps2Screen.outputX =:> transforms.rightRotateBy.cx
map.gps2Screen.outputY =:> transforms.rightRotateBy.cy


// Zoom management

s2l.outX ::> transforms.rightScaleBy.cx
s2l.outY ::> transforms.rightScaleBy.cy

Spike endZoomIn
Spike endZoomOUt
//Spike in order to prevent giving a falsy value to zoom
map.zoom == 20 -> endZoomIn
map.zoom == 3 -> endZoomOUt
Spike zoomIn
Spike zoomOut

//Accumulator for the wheel usage in order to take in account the apple wheel
AdderAccumulator zoomInAcc (0,0,7)
AdderAccumulator zoomOutAcc (0,-7,0)

AssignmentSequence resetZoomAcc (1) {
  0 =: zoomInAcc.result,zoomOutAcc.result
}
zoomInAcc.result == zoomInAcc.clamp_max -> zoomIn,resetZoomAcc
zoomOutAcc.result == zoomOutAcc.clamp_min -> zoomOut,resetZoomAcc
GenericMouse.wheel.dy =:> zoomInAcc.input,zoomOutAcc.input

//FSM which deal with the zoom activated by the wheel mouse
FSM zoomFSM {
  State zoomAllowed{
    zoomIn -> map.zoomInCursor
    zoomOut -> map.zoomOutCursor
  }
  State zoomInNotAllowed{
    zoomOut -> map.zoomOutCursor
  }
  State zoomOutNotAllowed{
    zoomIn -> map.zoomInCursor
  }
  zoomAllowed -> zoomInNotAllowed (endZoomIn)
  zoomAllowed -> zoomOutNotAllowed (endZoomOUt)
  zoomInNotAllowed -> zoomAllowed (map.zoomOutCursor)
  zoomOutNotAllowed -> zoomAllowed (map.zoomInCursor)
}


Spike redraw_zoom_center
Spike redraw_zoom_pointed
Spike continue_zoom_center

AssignmentSequence  zoom_assign (1){
  (map.zoom <20) ? $map.zoom + 1 : 20 =: map.zoom 
}
AssignmentSequence  unzoom_assign (1){
  (map.zoom >3) ? $map.zoom - 1 : 3 =: map.zoom
}

map.zoomInCentered -> zoom_assign
map.zoomOutCentered -> unzoom_assign
map.changeLocation -> redraw_zoom_center

map.zoom->  redraw_zoom_center


//Redraw tiles when zooming
//Same thing as the initialisation
redraw_zoom_center -> (map){
  int z = map.zoom 
  if(z > 2 && z <21){
    //Compute of the number of each tile needed 
    int firstXtile_ =(begin_x(z, map.longitude, map.column))
    int lastXtile_ =(end_x(z, map.longitude,map.column))
    int firstYtile_ =(begin_y(z, map.latitude,map.row))
    int lastYtile_ =(end_y(z,map.latitude,map.row))
    int k = 1
    for(int i = firstXtile_; i <= lastXtile_; i++)
    {
      int x_index = mod_function(i,pow(2,z))
      for (int j = firstYtile_; j <= lastYtile_; j++)
      {
        //update of the tile path according to the new tile number
        map.tiles.[k].path = format_cache(z,x_index,j,toString(map.tileSource))
        k++
        }
      }
    }
    //update of the topLeftpath in order to keep coherence with the gps2Screen module
    map.topLeftpath = toString(map.tiles.[1].path)
  }

//AssignmentSequence which compute the new lat/lon coordinates of the view's center after zoom cursor centrered
AssignmentSequence new_gps_pointed_zoom (1){
  map.longitude + 360/(pow(2,map.zoom+1)*256)*(map.pointedX - map.clipping.width/2) =: map.longitude
  map.latitude + 360/(pow(2,map.zoom+1)*256)*(map.clipping.height/2 - map.pointedY )*cos(map.lati_pointed*3.14159265359/180) =: map.latitude
}
AssignmentSequence new_gps_pointed_unzoom (1){
  map.longitude - 360/(pow(2,map.zoom)*256)*(map.pointedX - map.clipping.width/2) =: map.longitude
  map.latitude + 360/(pow(2,map.zoom)*256)*(map.pointedY -map.clipping.height/2 )*cos(map.lati_pointed*3.14159265359/180) =: map.latitude
}

map.zoomInCursor -> zoom_assign,redraw_zoom_pointed,new_gps_pointed_zoom

map.zoomOutCursor-> unzoom_assign,redraw_zoom_pointed,new_gps_pointed_unzoom

//redraw tiles when unzooming pointed
//same as redraw_centered but with a different offset
redraw_zoom_pointed -> (map){
  int z = map.zoom
  int firstXtile_ =(begin_x_pointed(z, map.longi_pointed,map.num_tile,map.row))
  int lastXtile_ =(end_x_pointed(z, map.longi_pointed,map.num_tile,map.row,map.column))
  int firstYtile_ =(begin_y_pointed(z, map.lati_pointed,map.num_tile,map.row))
  int lastYtile_ =(end_y_pointed(z,map.lati_pointed,map.num_tile,map.row))
  int k = 1
  for(int i = firstXtile_; i <= lastXtile_; i++)
  {
    int x_index = mod_function(i,pow(2,z))
    for (int j = firstYtile_; j <= lastYtile_; j++)
    {
      map.tiles.[k].path = format_cache(z,x_index,j,toString(map.tileSource))  
      k++
    }
  }
  map.topLeftpath = toString(map.tiles.[1].path)
}



// Pan management

Spike process_new_gps
Spike release_pan
AdderAccumulator acc_x (0,0,0)
AdderAccumulator acc_y (0,0,0)
AdderAccumulator acc_x_gps (0,0,0)
AdderAccumulator acc_y_gps (0,0,0)
//Connector to recompute the gps coordinates of the center's map view
acc_x_gps.result -> process_new_gps
acc_y_gps.result -> process_new_gps

Spike forceNoPan
Spike panningSpike
FSM panFsm {
  State idle 

  State pressed {
    // Memorize press position in local coordinates
    frame.press.x =: s2l.inX
    frame.press.y =: s2l.inY
  }

  State panning {
    0 =: acc_x_gps.result
    0 =: acc_y_gps.result
    Double init_x (0)
    Double init_y (0)
    s2l.outX =: init_x
    s2l.outY =: init_y
    frame.move.x =:> s2l.inX
    frame.move.y =:> s2l.inY
    // Compute added translation
    FSM correct_pan{
      State pan{
        //Test to prevent going to far north
        Spike testHaut
        map.latitude > 81 && (s2l.outY - init_y) > 0 -> testHaut
        //Test to prevent going to far south
        Spike testBas
        map.latitude < - 81 && (s2l.outY - init_y) < 0 -> testBas
        s2l.outX - init_x =:> transforms.rightTranslateBy.dx,acc_x.input,acc_x_gps.input, map.anchorX_acc.input
        s2l.outY - init_y =:> transforms.rightTranslateBy.dy,acc_y.input,acc_y_gps.input, map.anchorY_acc.input
      }
      State no_pan
      pan -> no_pan (pan.testHaut)
      pan -> no_pan (pan.testBas)
    }
  }

  idle -> pressed (map.press)
  pressed -> idle (frame.release)
  pressed -> panning (frame.move,panningSpike)
  panning -> idle (frame.release,release_pan)
  panning -> idle (forceNoPan)
}

Int acc_x_temp (0)
Int acc_y_temp (0)
release_pan -> (this){
  this.acc_x_temp = 0 
  this.acc_y_temp = 0 
  this.acc_x_gps.result = 0
  this.acc_y_gps.result = 0
}

//Recomputing of the gps coordinates. The algorithm is based on an approximation of the distance corresponding to one pixel
process_new_gps -> (this){
  int pixelX = this.acc_x_gps.result - this.acc_x_temp
  double dif_long =-pixelX/256.0 *360/pow(2,this.map.zoom)
  int pixelY = this.acc_y_gps.result -this.acc_y_temp
  double dif_lat = pixelY/256.0 * 360/pow(2,this.map.zoom)*cos(this.map.latitude*3.14159265359/180)
  this.map.longitude = this.map.longitude + dif_long
  this.map.latitude = this.map.latitude + dif_lat
  if(this.map.longitude >= 180)
  {
    this.map.longitude = -180 + (this.map.longitude -180)
  }
  else if(this.map.longitude <= -180)
  {
    this.map.longitude = 180 + (this.map.longitude +180)
  }
  if(this.map.latitude >85)
  {
    this.map.latitude = 85
  }
  else if(this.map.latitude < -85)
  {
    this.map.latitude = -85
  }
  this.acc_x_temp = this.acc_x_gps.result
  this.acc_y_temp = this.acc_y_gps.result
}

//Action for each direction of pan
Spike moveUp
Spike moveDown
Spike moveRight
Spike moveLeft


Sorter sorter (map.tiles, "num_tileT")
//Minimum value to acitvate the replacing of tiles.
Int val (250)


(acc_y.result > val) ->moveUp

//Move up trigger a algorithm that move to the top the lowest line of tile. In order to create the illusion of pan
moveUp-> (map){
  for(int i = 1; i <=map.column; i ++){
    int before = $map.tiles.[map.row*i].y 
    //Changing the tile coordinates to the top
    map.tiles.[map.row*i].y = before -map.row*256
    map.tiles.[map.row*i].num_tileT = map.row*(i-1) + 1
    string path = toString(map.tiles.[map.row*(i-1)+1].path)
    int x = parseX(path)
    int y = parseY(path) - 1 
    //update of the tile path 
    map.tiles.[map.row*i].path = format_cache(map.zoom,x,y,toString(map.tileSource))

  } 
  for(int k = 1; k < $map.tiles.size; k ++ ){
    if(mod_function(k,map.row) != 0){
      //update of the tile number
      map.tiles.[k].num_tileT = map.tiles.[k].num_tileT + 1
    }
  }
  run map.pz.sorter.sort
  map.topLeftpath = toString(map.tiles.[1].path)
  map.pz.acc_y.result = 0
  map.originX = map.tiles.[1].x
  map.originY = map.tiles.[1].y
}

(acc_y.result < -val) -> moveDown
//same as moveUp but the top comes to the bottom
moveDown -> (map){
  for(int i = 1; i <= map.column; i++){
    int before = $map.tiles.[map.row*(i-1) + 1].y
    map.tiles.[map.row*(i-1) + 1].y = before + map.row*256
    map.tiles.[map.row*(i-1) + 1].num_tileT = map.row*i
    string path = toString(map.tiles.[map.row*i].img.path)
    int x = parseX(path)
    int y = parseY(path) + 1
    map.tiles.[map.row*(i-1) + 1].path = format_cache(map.zoom, x,y,toString(map.tileSource))
  }
  for(int k = 1; k<=$map.tiles.size; k++){
    if(mod_function(k,map.row) != 1){
      map.tiles.[k].num_tileT = map.tiles.[k].num_tileT -1 
    }
  }
  run map.pz.sorter.sort
  map.topLeftpath = toString(map.tiles.[1].path)
  map.pz.acc_y.result = 0
  map.originX = map.tiles.[1].x
  map.originY = map.tiles.[1].y
}

(acc_x.result > val) -> moveLeft
//same as moveUp but the right column goes to the left side
moveLeft -> (map){
  for(int i = 1; i <=map.row; i ++){
    int before = $map.tiles.[i + map.row*(map.column - 1)].x 
    map.tiles.[i+map.row*(map.column - 1)].x = before  - map.column*256
    map.tiles.[i+map.row*(map.column - 1)].num_tileT = i 
    string path = toString(map.tiles.[i].path)
    int x = (parseX(path) - 1)>=0 ? parseX(path) -1 : pow(2,map.zoom) -1 
    int y = parseY(path) 
    map.tiles.[map.row*(map.column - 1) + i].path = format_cache(map.zoom,x,y,toString(map.tileSource))
  } 
  for(int k = 1; k < $map.tiles.size; k ++ ){
    if(k <= map.row*(map.column - 1)){
      map.tiles.[k].num_tileT = map.tiles.[k].num_tileT + map.row
    }
  }
  run map.pz.sorter.sort
  map.topLeftpath = toString(map.tiles.[1].path)
  map.pz.acc_x.result = 0
  map.originX = map.tiles.[1].x
  map.originY = map.tiles.[1].y

}

(acc_x.result < -val) -> moveRight
//same as moveUp but the left column goes to the right side
moveRight -> (map){
  for(int i = 1; i <=map.row; i ++){
    int before = $map.tiles.[i].x
    map.tiles.[i].x = before + map.column*256
    map.tiles.[i].num_tileT = i + map.row*(map.column - 1)
    string path = toString(map.tiles.[map.row*(map.column - 1) + i].path)
    int x = mod_function(parseX(path) + 1,pow(2,map.zoom)) 
    int y = parseY(path) 
    map.tiles.[i].path = format_cache(map.zoom,x,y,toString(map.tileSource))
  } 
  for(int k = 1; k <= $map.tiles.size; k ++ ){
    if(k > map.row){
      map.tiles.[k].num_tileT = map.tiles.[k].num_tileT - map.row
    }
  }
  run map.pz.sorter.sort
  map.topLeftpath = toString(map.tiles.[1].path)
  map.pz.acc_x.result = 0
  map.originX = map.tiles.[1].x
  map.originY = map.tiles.[1].y
}


}