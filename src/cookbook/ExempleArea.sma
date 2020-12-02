use core
use base
use gui


import Map.models.area.MapArea
import Map.models.area.AreaPoints

_define_
ExempleArea (Process map_){
	//this example is here to show how to draw on the map an area defined in a csv file
	map aka map_
	// Parser of the csv file
	AreaPoints areaPoints (map,"./saved_trajectory/tma_blagnac.csv")
	//After parsing, the drawing on the map
	areaPoints.endCreation -> (this){
		addChildrenTo this.map.layers {
			MapArea mapArea (this.map, this.areaPoints)
			//spike to trigger the tow spike present in mapArea
			this.map.frame.key\-pressed == 83 -> mapArea.show
			this.map.frame.key\-pressed == 72 -> mapArea.hide
		}
	}

	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 600, "Press \"H\" to hide area")
	Text _ ($map.t.tx, $map.t.ty + $map.clipping.height + 625, "Press \"S\" to show area")

}