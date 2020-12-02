use core
use base
use gui

import Map.utils.tile.ParserMapPath

_native_code_
%{
    #include<cmath>
    #include<math.h>
%}
//Definition of the c++ algorithm in smala 
//Used but not for the initialisation
_define_
Tile2Coords(Process path_){
    path aka path_
    ParserMapPath parser (path)
    Double pi (3.1415926535897932384626433832795)

    Pow pow (2,$parser.z)
    parser.z =:> pow.exponent

    Double longitude (0)
    Double latitude (0)

    parser.x/pow.result*360 -180 =:> longitude

    Double temp (0)
    pi - 2*pi*parser.y/pow.result =:> temp

    180 / pi *atan(sinh(temp)) =:> latitude
    
}