/*
 *  djnn Smala compiler
 *
 *  The copyright holders for the contents of this file are:
 *    Ecole Nationale de l'Aviation Civile, France (2017)
 *  See file "license.terms" for the rights and conditions
 *  defined by copyright holders.
 *
 *
 *  Contributors:
 *    Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
 *
 */
use core
use base
use display
use gui

import Map.models.point.PointGps

_define_
NewCircHandler (Process map, Process ref) {  
  DerefDouble dd_r (ref, "r", DJNN_GET_ON_CHANGE)
  PointGps p ($map.lati_pointed, $map.longi_pointed, map)
  PointGps p_current ($map.lati_pointed, $map.longi_pointed, map)
  AssignmentSequence p_assign (1){
    map.lati_pointed =: p.latitude
    map.longi_pointed =: p.longitude
  }
  map.frame.press -> p_assign
  map.longi_pointed =:> p_current.longitude
  map.lati_pointed =:> p_current.latitude

  Ref null_ref (null)
  Bool test_ref (0)
  null_ref == ref =:> test_ref
  FSM fsm {
    State moving {
      // 0 =: ref.$value.c.pickable
      sqrt (pow(p_current.x - p.x,2) + pow(p_current.y - p.y,2)) => dd_r.value
    }
    State idle {
      // 1 =: ref.$value.c.pickable
      null_ref =: ref
    }
    moving->idle (map.frame.release)
    idle->moving (test_ref.false)
  }
}
