use core
use base
use gui

import Map.models.point.PointGps

_define_
MyRectangle (Process map)
{
  this =: map.obj_selected
  PointGps p ($map.lati_pointed, $map.longi_pointed, map)
  FillColor fc (178,34,34)
  fill aka fc.value
  OutlineColor oc (178,34,34)
  stroke aka oc.value
  FillOpacity fo (0.3)
  OutlineOpacity oo (0.8)
  Rectangle r ($p.x, $p.y, 4, 4, 5, 5)
  p.x =:> r.x
  p.y =:> r.y 
  width aka r.width
  height aka r.height
  rx aka r.rx
  ry aka r.ry
  x aka r.x
  y aka r.y
  map.obj_selected = &this
  r.press->{this =: map.obj_selected}
  0 =: r.pickable 
}