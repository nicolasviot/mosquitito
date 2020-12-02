use core
use base
use display
use gui

import Map.utils.tile.ParserMapPath
import Map.utils.tile.Tile2Coords

_native_code_
%{
    #include<cmath>
%}
//Convert a x,y frame coordinates to a lat/lon coords
_define_
Screen2Gps(Process map){

    String path ("")
    map.pointed_path =:> path

    Int inputX (0)

    Int inputY (0)

    Double outputLon (0)

    Double outputLat (0)

    ParserMapPath parser (path)

    Double deg2rad (0.01745329251994329576923690768489) // pi/180
    Double tile_width_degree (360/(pow(2,$parser.z)))
    360/(pow(2,parser.z)) =:> tile_width_degree

    Tile2Coords tile2coords (path)

    inputX/256 * tile_width_degree + tile2coords.longitude =:> outputLon

    tile2coords.latitude - inputY/256 * (tile_width_degree*cos(tile2coords.latitude*deg2rad)) =:> outputLat


}