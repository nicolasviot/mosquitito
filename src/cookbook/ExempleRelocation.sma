use core
use base
use gui

import Map.widgets.Button

_define_
ExempleRelocation (Process map_){
	//Example to show how the api give you the possibility to change location very simply. The only thing you must do is to update the value of 
	// map.new_latitude and map.new_longitude 
	map aka map_ 
	frame aka map.frame


	Component lat_component {
		OutlineWidth _ (5)
		OutlineColor _ (70,70,70)
		FillColor col (100,100,100)
		Rectangle lat_rect (250,550,50,25,0,0)
	}
	Component lon_component {
		OutlineWidth _ (5)
		OutlineColor _ (70,70,70)
		FillColor col (100,100,100)
		Rectangle lon_rect (250,585,50,25,0,0)
	}
	Component city_component {
		OutlineWidth _ (5)
		OutlineColor _ (70,70,70)
		FillColor col (100,100,100)
		Rectangle city_rect (505,570,50,25,0,0)
	}

	Text lat (180,565,"New lat : ")
	Text lon (180,600,"New lon : ")
	Text city (410,585,"Choose City : ")
	Text city_available (430,555,"Paris,New York, Tokyo, Sydney, Santiago")
	FillColor _ (255,255,255)
	Text lat_text (0,0,"")
	Text lon_text (0,0,"")
	Text city_text (0,0,"")
	lat_component.lat_rect.x + lat_component.lat_rect.width/2 - lat_text.width/2 =:> lat_text.x
	lat_component.lat_rect.y + lat_component.lat_rect.height/2 +lat_text.height/2 -2=:> lat_text.y
	lat_text.width > lat_component.lat_rect.width ? lat_text.width +10: lat_component.lat_rect.width =:> lat_component.lat_rect.width

	lon_component.lon_rect.x + lon_component.lon_rect.width/2 - lon_text.width/2 =:> lon_text.x
	lon_component.lon_rect.y + lon_component.lon_rect.height/2 +lon_text.height/2 -2=:> lon_text.y
	lon_text.width > lon_component.lon_rect.width ? lon_text.width + 10: lon_component.lon_rect.width =:> lon_component.lon_rect.width

	city_component.city_rect.x + city_component.city_rect.width/2 - city_text.width/2 =:> city_text.x
	city_component.city_rect.y + city_component.city_rect.height/2 +city_text.height/2 -2=:> city_text.y
	city_text.width > city_component.city_rect.width ? city_text.width + 10: city_component.city_rect.width =:> city_component.city_rect.width

	TextAccumulator lat_acc ("")
	lat_acc.state =:> lat_text.text
	TextAccumulator lon_acc ("")
	lon_acc.state =:> lon_text.text
	TextAccumulator city_acc ("")
	city_acc.state =:> city_text.text
	Button changeLoc (frame,"change new gps",200,650)
	Button changeLocCity (frame,"change City",480,650)


	Double latParis (48.8534)
	Double lonParis (2.3488)
	Double latNY (40.71427)
	Double lonNY (-74.00597)
	Double latTokyo (35.652832)
	Double lonTokyo (139.839478)
	Double latSydney (-33.86785)
	Double lonSydney (151.20732)
	Double latSantiago (-33.45694)
	Double lonSantiago (-70.64827)
	String resTemp ("")

	TextComparator tParis ("", "Paris")
	resTemp =:> tParis.left
	TextComparator tNY ("", "New York")
	resTemp =:>tNY.left
	TextComparator tTokyo ("", "Tokyo")
	resTemp =:>tTokyo.left
	TextComparator tSydney ("", "Sydney")
	resTemp =:>tSydney.left
	TextComparator tSantiago ("", "Santiago")
	resTemp=:>tSantiago.left

	tParis.output.true -> {latParis =: map.new_latitude
		lonParis =: map.new_longitude}
	tNY.output.true -> {latNY=: map.new_latitude
		lonNY =: map.new_longitude}
	tTokyo.output.true -> {latTokyo =: map.new_latitude
		lonTokyo =: map.new_longitude}
	tSydney.output.true -> {latSydney=: map.new_latitude
		lonSydney =: map.new_longitude}
	tSantiago.output.true -> {latSantiago =: map.new_latitude
		lonSantiago =: map.new_longitude}				


	Spike outSelection
	AssignmentSequence validation (1) {
		lat_text.text =: map.new_latitude
		lon_text.text =: map.new_longitude
	}
	changeLoc.click -> outSelection,validation
	changeLocCity.click -> outSelection
	changeLocCity.click -> {city_text.text =: resTemp}

	Spike toLon 
	Spike toLat
	FSM choosed {
		State idle {
			100 =: lat_component.col.r
			100 =: lat_component.col.g
			100 =: lat_component.col.b
			100 =: lon_component.col.r
			100 =: lon_component.col.g
			100 =: lon_component.col.b
			100 =: city_component.col.r
			100 =: city_component.col.g
			100 =: city_component.col.b
		}
		State lat_choose{
			200 =: lat_component.col.r
			200 =: lat_component.col.g
			200 =: lat_component.col.b
			100 =: lon_component.col.r
			100 =: lon_component.col.g
			100 =: lon_component.col.b
			100 =: city_component.col.r
			100 =: city_component.col.g
			100 =: city_component.col.b
			frame.key\-pressed_text => lat_acc.input
			frame.key\-pressed == DJN_Key_Backspace -> lat_acc.delete
			frame.key\-pressed == DJN_Key_Tab -> toLon
		}
		State lon_choose{
			200 =: lon_component.col.r
			200 =: lon_component.col.g
			200 =: lon_component.col.b
			100 =: lat_component.col.r
			100 =: lat_component.col.g
			100 =: lat_component.col.b
			100 =: city_component.col.r
			100 =: city_component.col.g
			100 =: city_component.col.b
			frame.key\-pressed_text => lon_acc.input
			frame.key\-pressed == DJN_Key_Backspace -> lon_acc.delete
			frame.key\-pressed == DJN_Key_Tab -> toLat
		}
		State city_choose{
			200 =: city_component.col.r
			200 =: city_component.col.g
			200 =: city_component.col.b
			100 =: lat_component.col.r
			100 =: lat_component.col.g
			100 =: lat_component.col.b
			100 =: lon_component.col.r
			100 =: lon_component.col.g
			100 =: lon_component.col.b
			frame.key\-pressed_text => city_acc.input
			frame.key\-pressed == DJN_Key_Backspace -> city_acc.delete
		}

		idle -> lat_choose (lat_component.lat_rect.press)
		idle -> lon_choose (lon_component.lon_rect.press)
		idle -> city_choose (city_component.city_rect.press)
		lat_choose-> idle (outSelection)
		lon_choose-> idle (outSelection)
		city_choose -> idle (outSelection)
		city_choose -> lon_choose (lon_component.lon_rect.press)
		city_choose -> lat_choose (lat_component.lat_rect.press)
		lat_choose -> lon_choose (lon_component.lon_rect.press)
		lon_choose -> lat_choose (lat_component.lat_rect.press)
		lat_choose -> lon_choose (toLon)
		lon_choose -> lat_choose (toLat)
	
	}
}