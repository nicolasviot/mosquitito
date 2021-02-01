
use core
use base
use display
use gui
import Map.widgets.Block


_define_
FlightPlan (Process frame, string name, double x_, double y_, double _width, double _height) {
  Translation t (x_, y_)

  /*----- interface -----*/
  x aka t.tx
  y aka t.ty
  /*----- interface -----*/
  
 svg1 = loadFromXML ("ressources/flightPlan.svg")

  g << svg1.background
  g.bg.width = _width
  g.bg.height = _height
  g.text_name.text = name 

  Block takeoff(frame, "takeoff", "1", 20, 50, 360, 50)
  Block circle(frame, "Circle around Wp1", "2", 20, 130, 360, 50)  
}
