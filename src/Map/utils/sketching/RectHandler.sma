/*
 *	djnn Smala compiler
 *
 *	The copyright holders for the contents of this file are:
 *		Ecole Nationale de l'Aviation Civile, France (2017)
 *	See file "license.terms" for the rights and conditions
 *	defined by copyright holders.
 *
 *
 *	Contributors:
 *		Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
 *
 */
 use core
 use base
 use display
 use gui

 _define_
 RectHandler (Process f, Process rect_selected) {

  Ref locRef (null)
  DerefDouble dd_x (rect_selected, "x", DJNN_GET_ON_CHANGE)
  DerefDouble dd_y (rect_selected, "y", DJNN_GET_ON_CHANGE)
  DerefDouble dd_w (rect_selected, "width", DJNN_GET_ON_CHANGE)
  DerefDouble dd_h (rect_selected, "height", DJNN_GET_ON_CHANGE)
  rect_selected =:> locRef
  Ref nul_ref (null)
  Spike new_ref
  (locRef != nul_ref)->new_ref

  int sz = 7

  Switch mask (idle) {
    Component idle
    Component active {
      Double init_w (0)
      Double init_h (0)
      Double init_x (0)
      Double init_y (0)

      NoFill _
      NoOutline _
      Rectangle r_mask (0, 0, 0, 0, 0, 0)
      dd_x.value =:> r_mask.x
      dd_y.value =:> r_mask.y
      dd_w.value =:> r_mask.width
      dd_h.value =:> r_mask.height

      FillColor _ (#FFFFFF)
      FillOpacity _ (0.8)
      OutlineColor _ (#000000)
      OutlineWidth _ (0.5)

      Rectangle top_left (0, 0, sz, sz, 0, 0)
      Rectangle top_middle (0, 0, sz, sz, 0, 0)
      Rectangle top_right (0, 0, sz, sz, 0, 0)
      Rectangle middle_right (0, 0, sz, sz, 0, 0)
      Rectangle middle_left (0, 0, sz, sz, 0, 0)
      Rectangle bottom_left (0, 0, sz, sz, 0, 0)
      Rectangle bottom_right (0, 0, sz, sz, 0, 0)
      Rectangle bottom_middle (0, 0, sz, sz, 0, 0)

      dd_x.value + (dd_w.value/2) - (sz/2) =:> bottom_middle.x
      dd_y.value + dd_h.value - (sz/2) =:> bottom_middle.y

      dd_x.value + dd_w.value - (sz/2) =:> bottom_right.x
      dd_y.value + dd_h.value - (sz/2) =:> bottom_right.y

      dd_x.value - (sz/2) =:> bottom_left.x
      dd_y.value + dd_h.value - (sz/2) =:> bottom_left.y

      dd_x.value - (sz/2) =:> middle_left.x
      dd_y.value  + (dd_h.value/2) - (sz/2) =:> middle_left.y

      dd_x.value + dd_w.value - (sz/2) =:> middle_right.x
      dd_y.value  + (dd_h.value/2) - (sz/2) =:> middle_right.y

      dd_x.value + dd_w.value - (sz/2) =:> top_right.x
      dd_y.value - (sz/2) =:> top_right.y

      dd_x.value + (dd_w.value/2) - (sz/2) =:> top_middle.x
      dd_y.value - (sz/2) =:> top_middle.y

      dd_x.value - (sz/2) =:> top_left.x
      dd_y.value - (sz/2) =:> top_left.y


      FSM fsm_top_middle {
        State idle
        State moving {
          dd_y.value =: init_y
          dd_h.value =: init_h
          init_y - f.move.y + init_h =:> dd_h.value
          f.move.y =:> dd_y.value
        }
        idle->moving (top_middle.press)
        moving->idle (f.release)
      }

      FSM fsm_top_left {
        State idle
        State moving {
          dd_x.value =: init_x
          dd_y.value =: init_y
          dd_w.value =: init_w
          dd_h.value =: init_h
          init_x - f.move.x + init_w =:> dd_w.value
          f.move.x =:> dd_x.value
          init_y - f.move.y + init_h =:> dd_h.value
          f.move.y =:> dd_y.value
        }
        idle->moving (top_left.press)
        moving->idle (f.release)
      }

      FSM fsm_top_right {
        State idle
        State moving {
          dd_x.value =: init_x
          dd_y.value =: init_y
          dd_h.value =: init_h
          f.move.x - init_x =:> dd_w.value
          init_y - f.move.y + init_h =:> dd_h.value
          f.move.y =:> dd_y.value
        }
        idle->moving (top_right.press)
        moving->idle (f.release)
      }

      FSM fsm_middle_right {
        State idle
        State moving {
          dd_x.value =: init_x
          f.move.x - init_x =:> dd_w.value
        }
        idle->moving (middle_right.press)
        moving->idle (f.release)
      }

      FSM fsm_middle_left {
        State idle
        State moving {
          dd_x.value =: init_x
          dd_w.value =: init_w
          init_x - f.move.x + init_w =:> dd_w.value
          f.move.x =:> dd_x.value
        }
        idle->moving (middle_left.press)
        moving->idle (f.release)
      }

      FSM fsm_bottom_left {
        State idle
        State moving {
          dd_x.value =: init_x
          dd_y.value =: init_y
          dd_w.value =: init_w
          init_x - f.move.x + init_w =:> dd_w.value
          f.move.x =:> dd_x.value
          f.move.y - init_y =:> dd_h.value
        }
        idle->moving (bottom_left.press)
        moving->idle (f.release)
      }

      FSM fsm_bottom_right {
        State idle
        State moving {
          dd_x.value =: init_x
          dd_y.value =: init_y
          f.move.x - init_x =:> dd_w.value
          f.move.y - init_y =:> dd_h.value
        }
        idle->moving (bottom_right.press)
        moving->idle (f.release)
      }

      FSM fsm_bottom_middle {
        State idle
        State moving {
          dd_y.value =: init_y
          f.move.y - init_y =:> dd_h.value
        }
        idle->moving (bottom_middle.press)
        moving->idle (f.release)
      }

      FSM fsm_middle {
        State moving {
          Double off_x (0)
          Double off_y (0)
          f.press.x - dd_x.value =: off_x
          f.press.y - dd_y.value =: off_y
          f.move.x - off_x =:> dd_x.value
          f.move.y - off_y =:> dd_y.value
        }
        State idle
        idle->moving (r_mask.press)
        idle->moving (new_ref)
        moving->idle (f.release)
      }
    }
  }
  locRef->(this) {
    p = getRef (&this.locRef)
    if (&p != 0) {
      this.mask.state = "active"
      } else {
        this.mask.state = "idle"
      }
    }
  }
