
use core
use base
use display
use gui



_define_
Block(Process frame, string name, string id, double x_, double y_, double width_, double height_) {

	Translation t(x_, y_)
	
	Spike activation
	Spike desactivation



	FSM activationFSM {
		State inactive{
			FillColor _(192, 192, 192)
			Rectangle bgInactif (0, 0, $width_, $height_, 5, 5)

			Text idInactif (0, 0, $id)
			Text nameInactif (5, 0, $name)


		// 	block << svg2.block
		// 	block.block_bg.x = 0
		// 	block.block_bg.y = 0
		// 	block.block_bg.width = $width_
		// 	block.block_bg.height = $height_

		// 	block.block_name.block_name.text = $name
		// 	block.block_name.block_name.x = 0
		// 	block.block_name.block_name.y = -50
			
		// 	block.block_index.block_index.text = $id
		// 	block.block_index.block_index.x = 0
		// 	block.block_index.block_index.y = -50
		// 	dump block.block_launch
		// 	block.block_launch.block_launch.origin_x = 0
		// 	block.block_launch.block_launch.origin_y = 0
		// 	dump block.block_name
		// 	dump block.block_index	
		}
		State active {

			FillColor _(36, 192, 36)
			Rectangle bgActif (30, 0, $width_, $height_, 5, 5)
			Text idActif(30, $height_ / 2, $id)
			FillColor _(192, 192, 192)
			Text nameInactif(35, $height_ / 2, $name)
			
			

			// block << svg2.block_1_
			// block.block_bg_1_.block_bg_1_.x = 30
			// block.block_bg_1_.block_bg_1_.y = 0
			// block.block_bg_1_.height = $height_
			// block.block_bg_1_.width = $width_
			
			// block.block_name_1_.block_name_1_.text = $name
			// block.block_name_1_.block_name_1_.x = -30
			// block.block_name_1_.block_name_1_.y = -100
			
			// block.block_index_1_.block_index_1_.text = $id
			// block.block_index_1_.block_index_1_.x = -30
			// block.block_index_1_.block_index_1_.y = -100
		}
	inactive -> active (inactive.bgInactif.press, activation)
	active -> inactive (active.bgActif.press, desactivation)
	}
}