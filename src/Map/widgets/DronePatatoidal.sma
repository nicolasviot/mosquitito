
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
    Int req_x(0)
    Int req_y(0)
    Double r ($width)	

	
	x aka _t.tx
	y aka _t.ty

	x + width * 0.5 =:> cx
	y + height * 0.5 =:> cy
    req_x + width * 0.5 =:> cx
    req_y + height * 0.5 =:> cy
    Rectangle bg(0, 0, 92, 78)
    
    FillColor grand_patatoide_color (0, 0, 0)
    Circle grand_patatoide ($width * 0.5, $height * 0.5, $width * 0.25)

    OutlineColor pin_color (0, 0, 200)
    Line pin ($cx, $cy, $cx, $cy)

    FillColor petit_patatoide_color (120, 120, 120)
    Circle petit_patatoide ($width * 0.5, $height * 0.5, $width * 0.125)

    dronefill aka grand_patatoide_color



    petit_patatoide.cx =:> pin.x1
    petit_patatoide.cy =:> pin.y1
    grand_patatoide.cx =:> pin.x2
    grand_patatoide.cy =:> pin.y2

    Rotation _r(_rotation, 0, 0)
    rot aka _r.a 
    width * 0.5 =:> _r.cx
    height * 0.5 =:> _r.cy

    FillColor drone_orientation_color(0, 0, 0)
    Circle drone_orientation ($width * 0.5, $height * 0.5 - $height * 0.140, $width * 0.065)


    FSM ALT_FSM{
    	State idle


    	State pressed{
    		petit_patatoide.move.y - y - _parent_y=:> petit_patatoide.cy
    	}

    	idle -> pressed (petit_patatoide.press)
    	pressed -> idle (petit_patatoide.release)
    }
	
}