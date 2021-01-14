
use core
use base
use display
use gui



_define_
FlightPlaneur (Process frame,double x_, double y_) {
  Translation t (x_, y_)

  /*----- interface -----*/
  x aka t.tx
  y aka t.ty
  /*----- interface -----*/
  FillColor _(255, 0, 0)
  Rectangle test (0,0, 500, 500)
}
