
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
  svg = loadFromXML("./ressources/personalsvg/constrainteditor/constraintpopup2.svg")
  Spike onoff

/*
  Ref null_ref (null)
  Ref toDrag (null)
  AssignmentSequence set_null (1) {
    null_ref =: toDrag
  }

  SimpleDrag _ (toDrag, frame)
*/
  // ? assigner une valeur
  background << svg.background
  properties << svg.constraintprop

  /*------ set properties -------*/
  background.constraintname.text = label
  properties.prop1.text = prop1
  properties.prop2.text = prop2
  properties.prop3.text = prop3
  properties.prop4.text  = prop4

  Double prop1value(0)
  /*------ set properties -------*/
  // default state : inactive
  
  FSM switchState_fsm{
    State inactive {
      switchstate << svg.constraintoff
      //dump switchstate
      switchstate.offgreen.rect.press -> onoff
      
    }
    State active {
      switchstate << svg.constrainton
      
      switchstate.onred.rect.press -> onoff
    }
    inactive -> active (onoff)
    active -> inactive (onoff)
    }
   //dump switchState
    

}
