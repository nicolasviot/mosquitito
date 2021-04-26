
use core
use base
use display
use gui
import Slider
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
  Spike noSpike
  Spike update_slider
  background << svg.background
  properties << svg.constraintprop
  background.constraintname.text = $label

  //consume mouseevents
  background.bg.press -> noSpike
  
  /*------ set properties -------*/
  
  Double xProp(564)
  Double yProp(0)
  Double zProp(0)
  Double headingProp(0)
  
  DoubleFormatter xFormatter (0,0)
  DoubleFormatter yFormatter (0,0)
  DoubleFormatter zFormatter (0,0)
  DoubleFormatter headingFormatter (0,0)
  
  Slider sliderX(frame, 180, 70, -150, 150, 200)     
  Slider sliderY(frame, 180, 102, -150, 150, 200)
  Slider sliderZ(frame, 180, 134, -150, 150, 200)
  Slider sliderHeading(frame, 180, 170, 0, 360, 200)

  sliderX.output =:> xProp  
  sliderY.output =:> yProp
  sliderZ.output =:> zProp
  

  (xProp + 150) * 200 / 300=:> sliderX.gobj.t_thumb.tx
  (yProp + 150) * 200 / 300=:> sliderY.gobj.t_thumb.tx
  (zProp + 150) * 200 / 300=:> sliderZ.gobj.t_thumb.tx


  sliderHeading.output =:> headingProp
  
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
