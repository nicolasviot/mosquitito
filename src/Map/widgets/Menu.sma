use core
use base
use display
use gui
import Slider
_define_
Menu (Process frame, double _x, double _y, string label1, string label2, string label3) {
	Translation _t(_x, _y)
	

	Spike menuItem1Selected
	Spike menuItem2Selected
	Spike menuItem3Selected


	TextAnchor _ (1)



	FillColor bgitem1 (140, 140, 140)
	Rectangle menuItem1(0, 0, 100, 300)
	FillColor text1(0, 0, 0)
	Text menu1text(50, 50, label1)
	
	FillColor bgitem2 (140, 140, 140)
	Rectangle menuItem2(0, 100, 100, 100)
	FillColor text1(0, 0, 0)
	Text menu2text(50, 150, label2)
	
	FillColor bgitem3 (140, 140, 140)
	Rectangle menuItem3(0, 200, 100, 100)
	FillColor text1(0, 0, 0)
	Text menu3text(50, 250, label3)


	FSM menuItem1FSM{
		State idle{
			140 =: bgitem1.r
			140 =: bgitem1.g
			140 =: bgitem1.b
		}
		State selected{
			164 =: bgitem1.r
			164 =: bgitem1.g
			164 =: bgitem1.b
		}
		idle -> selected (menuItem1.left.press)
		selected -> idle (menuItem1.left.release, menuItem1Selected)
		selected -> idle (menuItem2.left.release)
		selected -> idle (menuItem3.left.release)
	}

	FSM menuItem2FSM{
		State idle{
			140 =: bgitem2.r
			140 =: bgitem2.g
			140 =: bgitem2.b
		}
		State selected{
			164 =: bgitem2.r
			164 =: bgitem2.g
			164 =: bgitem2.b
		}
		idle -> selected (menuItem2.left.press)
		selected -> idle (menuItem2.left.release, menuItem2Selected)
		selected -> idle (menuItem1.left.release)
		selected -> idle (menuItem3.left.release)
	}

	FSM menuItem3FSM{
		State idle{
			140 =: bgitem3.r
			140 =: bgitem3.g
			140 =: bgitem3.b
		}
		State selected{
			164 =: bgitem3.r
			164 =: bgitem3.g
			164 =: bgitem3.b
		}
		idle -> selected (menuItem3.left.press)
		selected -> idle (menuItem3.left.release, menuItem3Selected)
		selected -> idle (menuItem1.left.release)
		selected -> idle (menuItem2.left.release)
	}



}
