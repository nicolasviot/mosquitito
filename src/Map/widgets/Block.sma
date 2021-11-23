
use core
use base
use display
use gui



_define_
Block(string name_, string id_, double x_, double y_, double width_, double height_) {

	String name("")
	String id("")


	svg = loadFromXML ("./ressources/flightPlan.svg")
	graphics << svg.block 



	name =:> graphics.block_name.text
	id =:> graphics.block_index.text


}