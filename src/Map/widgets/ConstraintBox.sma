
use core
use base
use display
use gui
import gui.interactors.SimpleDrag
_define_
ConstraintBox (Process frame, string label, double x_, double y_, string prop1, string prop2, string prop3, string prop4) {
  Translation t (x_, y_)

  /*----- interface -----*/
  x aka t.tx
  y aka t.ty
  /*----- interface -----*/
  svg = loadFromXML("./ressources/constraintpopup3.svg")
  Spike onSpike
  Spike offSpike




  // ? assigner une valeur
  background << svg.background
  properties << svg.constraintprop

  /*------ set properties -------*/
  Double xProp(564)
  Double yProp(0)
  Double zProp(0)
  Double headingProp(0)
  DoubleFormatter xFormatter (0,0)
  DoubleFormatter yFormatter (0,0)
  DoubleFormatter zFormatter (0,0)
  DoubleFormatter headingFormatter (0,0)
  xProp =:> xFormatter.input
  yProp =:> yFormatter.input
  zProp =:> zFormatter.input
  headingProp =:> headingFormatter.input
  xFormatter.output =:> properties.x_val.text
  yFormatter.output =:> properties.y_val.text
  zFormatter.output =:> properties.z_val.text  
  headingFormatter.output =:> properties.heading_val.text

  /*------ set properties -------*/
  // default state : off    
  FSM onOffSwitch{
    State off{
      g << svg.constraintoff
    }
    State on {
      g << svg.constrainton
    }

    off -> on (off.g.offgreen.press, onSpike)
    on -> off (on.g.onred.press, offSpike)
  }







}
