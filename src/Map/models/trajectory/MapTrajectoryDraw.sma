use core
use base
use gui

_native_code_
%{
	#include "Map/cpp/tile2coords.h"
	#include<cmath>
%}

_define_
MapTrajectoryDraw (Process map, Process trajectorySteps,string name_ ){
	//Object that create the drawing of the map and the polygon around if you want to be able to select it
	steps aka trajectorySteps.steps
	angles aka trajectorySteps.angles
	String name ($name_)
	OutlineColor outlineColor (178,34,34)
	OutlineWidth outlineWidth (3) 
	NoFill _ 
	Polyline path {
		for(int i = 1; i <= $steps.size; i++){
			Point p_ ($steps.[i].x,$steps.[i].y)
		}
	}

	//Invisble polygon that surround all the path in order to be able to interact with it by right_clicking
	NoOutline _
	Polygon polygon {
		for(int i = 1; i <= 2*$steps.size; i++){
			Point p_ (0,0)
		}
	}
	Double deg2rad (0.01745329251994329576923690768489) // pi/180
	// offset of the polygon around the path
	Int offset (10)
	

	for(int i = 1; i <= $this.steps.size; i++){
		(this.steps.[i].x + 0) =:> this.path.points.[i].x
		(this.steps.[i].y + 0) =:> this.path.points.[i].y
		int other_ind = $this.polygon.points.size - i
		(this.steps.[i].x + this.offset*cos(this.angles.[i].output*this.deg2rad)) =:> this.polygon.points.[i].x
		(this.steps.[i].y + this.offset*sin(this.angles.[i].output*this.deg2rad)) =:> this.polygon.points.[i].y
		(this.steps.[i].x - this.offset*cos(this.angles.[i].output*this.deg2rad)) =:> this.polygon.points.[other_ind].x
		(this.steps.[i].y - this.offset*sin(this.angles.[i].output*this.deg2rad)) =:> this.polygon.points.[other_ind].y
	}
	(this.steps.[1].x - this.offset*cos(this.angles.[1].output*this.deg2rad)) =:> this.polygon.points.[$this.polygon.points.size].x
	(this.steps.[1].y - this.offset*sin(this.angles.[1].output*this.deg2rad)) =:> this.polygon.points.[$this.polygon.points.size].y

	Spike right_click_path

	FSM pathFSM {
		State outPath{
			GenericMouse.left.press -> map.press
		}
		State inPath{
			GenericMouse.left.press -> map.press
			GenericMouse.right.press -> right_click_path
		}
		outPath->inPath (polygon.enter)
		inPath->outPath(polygon.leave)
	}
	Spike press 
	right_click_path -> press
}