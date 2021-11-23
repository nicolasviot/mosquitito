
use core
use base
use display
use gui

import Map.widgets.Block

_define_
BlockPannel(double x_, double y_, double width_, double height_, Process bus) {


FillColor grey (128, 128, 128)
Rectangle bg (x_ , y_ , width_, height_)

Component blocks{

}


Spike addBlock
String tempname("")
String tempID("")
bus.in.get_blocks.[2] =:> tempname
bus.in.get_blocks.[3] =:> tempID
tempID -> (this){
	addChildrenTo this.blocks{
		Translation _ (0, 50)
		Block block ("", "", 0, 0, 40, 40)
		this.tempname =: block.name
		this.tempID =: block.id
	}
}






}