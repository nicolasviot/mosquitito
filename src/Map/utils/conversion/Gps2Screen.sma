use core
use base
use display
use gui

import Map.utils.tile.Coords2Tile
import Map.utils.tile.ParserMapPath

_native_code_
%{
    #include <cmath>
%}
//Conversion class that convert lat/lon coordinates to x,y frame coordinates
_define_
Gps2Screen(Process map){
    String path ("")
    map.topLeftpath =:> path

    Int originX (0)
    map.originX =:> originX
    Int originY (0)
    map.originY =:> originY
    Double inputLon (0)

    Double inputLat (0)

    Int outputX (0)

    Int outputY (0)
    ParserMapPath parser(path)

    Coords2Tile coords2tile (inputLat, inputLon,map.zoom)

    (parser.x < coords2tile.tileX)?(coords2tile.tileX - parser.x)*256  + originX : (coords2tile.tileX + pow(2,parser.z) - parser.x)*256  + originX => outputX
    (coords2tile.tileY - parser.y)*256 + originY =:> outputY
    
}