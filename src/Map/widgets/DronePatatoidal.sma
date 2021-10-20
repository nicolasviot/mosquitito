
use core
use base
use display
use gui
import Map.widgets.Menu


_define_
DronePatatoidal(Process frame, double _x, double _y, double _rotation, double _parent_x, double _parent_y){
	Translation _t(_x, _y)

	Double width(92)
	Double height(78)
	Double cx (0)
	Double cy (0)
	

	
	x aka _t.tx
	y aka _t.ty

	x + width * 0.5 =:> cx
	y + height * 0.5=:> cy

    
    FillColor grand_patatoide_color (0, 200, 0)
    Circle grand_patatoide ($cx, $cy, $width * 0.25)

    OutlineColor pin_color (0, 0, 200)
    Line pin ($cx, $cy, $cx, $cy)

    FillColor petit_patatoide_color (200, 0, 0)
    Circle petit_patatoide ($cx, $cy, $width * 0.125)


    Rotation _r(_rotation, 0, 0)
    rot aka _r.a 
    width * 0.5 =:> _r.cx
    height * 0.5 =:> _r.cy

    FillColor drone_orientation_color(0, 0, 0)
    Circle drone_orientation ($cx, $cy - $width * 0.140, $width * 0.065)

    petit_patatoide.cx =:> pin.x1
    petit_patatoide.cy =:> pin.y1
    grand_patatoide.cx =:> pin.x2
    grand_patatoide.cy =:> pin.y2


    FSM ALT_FSM{
    	State idle


    	State pressed{
    		petit_patatoide.move.y - 2 * y - _parent_y =:> petit_patatoide.cy
    	}

    	idle -> pressed (petit_patatoide.press)
    	pressed -> idle (petit_patatoide.release)
    }
	
}