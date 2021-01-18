
use core
use base
use display
use gui



_define_
Block(Process frame, string name, int id, double x_, double y_, double width_, double height_) {

	Translation t(x_, y_)
	
	Spike activation
	Spike desactivation

	svg2 = loadFromXML("ressources/flightPlan.svg")
	dump svg2.block
	dump svg2.block_1_


	FSM activationFSM {
		State inactive{
			block << svg2.block
			block.block_bg.origin_x = 0
			block.block_bg.origin_y = 0
			//block.block_bg.width = $width_
			//block.block_bg.height = $height_
			block.block_name.block_name.text = $name
			//block.block_index.text = $id
					}
		State active {

			block << svg2.block_1_
			block.block_bg_1_.origin_x = 30
			block.block_bg_1_.origin_y = 0
			//block.block_bg_1_.width = $width_
			//block.block_bg_1_.height = $height_
			block.block_name_1_.block_name_1_.text = $name
			//block.block_index_1_.text = $id
		}
	inactive -> active (inactive.block.block_bg.press, activation)
	active -> inactive (active.block.block_bg_1_.press, desactivation)
	}
}