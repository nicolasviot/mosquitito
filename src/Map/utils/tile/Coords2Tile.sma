use core
use base
use gui

//Definition of the c++ algorithm in smala 
//Used but not for the initialisation
_define_
Coords2Tile(Process latitude_, Process longitude_, Process zoom_){
    latitude aka latitude_
    longitude aka longitude_
    zoom aka zoom_

    Double deg2rad (0.01745329251994329576923690768489) // pi/180
    Double pi (3.1415926535897932384626433832795)

    Pow pow (2,$zoom)
    zoom =:> pow.exponent

    Double tileX (0)
    Double tempTileX (0)
    
    (longitude + 180)/360.0 * pow.result =:> tileX

    Double tileY (0)
    Double latrad ($latitude*$deg2rad)
    latitude*deg2rad =:> latrad

    (1 - asinh(tan(latrad))/pi)/2 * pow.result =:> tileY


    
}