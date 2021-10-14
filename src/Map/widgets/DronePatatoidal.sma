
use core
use base
use display
use gui
import Map.widgets.Menu


_define_
Drone(Process frame, double _x, double _y, double _rotation){
	Translation _t(_x, _y)

	Double width(92)
	Double height(78)
	Double cx (0)
	Double cy (0)
	//Rotation _r(_rotation, 0, 0)
	NoFill _
	Rectangle bg(0, 0, 92, 78)
	Spike toogleShadow
	Spike untoogleShadow
	Double shadow (1)
	x aka _t.tx
	y aka _t.ty
	//rot aka _r.a
	x + width / 2 =:> cx
	y + height / 2 =:> cy
	width / 2 =:> _r.cx
    height / 2 =:> _r.cy
    FillColor petit_patatoide_color (200, 0, 0)
    Circle petit_patatoide ($cx, $cy, $width/4)
    FillColor grand_patatoide (0, 200, 0)
    Circle grand_patatoide ($cx, $cy, $width/2)
    Line pin ($cx, $cy, $cx, $cy)
    
    petit_patatoide.cx =:> pin.x1
    petit_patatoide.cy =:> pin.y1
    grand_patatoide.cx =:> pin.x2
    grand_patatoide.cy =:> pin.y2

    FSM ALT_FSM{
    	State idle



    }



	
	
}