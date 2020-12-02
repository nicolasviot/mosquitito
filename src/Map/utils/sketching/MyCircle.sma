use core
use base
use gui

import Map.models.point.PointGps

_define_
MyCircle (Process map)
{
  this =: map.obj_selected
  PointGps p ($map.lati_pointed, $map.longi_pointed, map)
  Translation pos (0, 0)
  p.x =:> pos.tx
  p.y =:> pos.ty
  FillColor fc (178,34,34)
  fill aka fc.value
  // NoFill _
  OutlineColor oc (178,34,34)
  stroke aka oc.value
  FillOpacity fo (0.1)
  OutlineOpacity oo (0.8)
  Circle c (0,0,4)
  Double r (0)
  r =:> c.r
  x aka pos.tx
  y aka pos.ty
  map.obj_selected = &this
  c.press->{this =: map.obj_selected}
  0 =: c.pickable
}