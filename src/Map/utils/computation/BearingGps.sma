use core
use base
use display
use gui


_native_code_
%{
	#include<cmath>
%}


//P1 & P2 must ave x,y children
//Compute the Bearing between the p1 and p2
//Order is crucial
_define_ 
BearingGps(Process p1_, Process p2_){
	
	y1 aka p1_.y
	x1 aka p1_.x
	y2 aka p2_.y
	x2 aka p2_.x

	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	Modulo mod (0,360)
	atan2(y2 -y1, x2-x1)/deg2rad + 90 =:> mod.left
	Double output (0)
	mod.result =:> output

}

