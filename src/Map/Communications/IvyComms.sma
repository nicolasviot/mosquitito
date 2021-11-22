use core
use base
use display
use gui
use comms



_define_
IvyComms (string busname) {

//Initialize an ivy bus on localhost
IvyAccess bus ("127.255.255.255:2010", busname, "READY")
    {
         // define your regexs 
         // better to use (\\S*) than (.*) eq: "pos=(\\S*) alt=(\\S*)"
         //FLIGHT_PARAM (ID 11)
        

        // Bindings positional data
        String regexGetLatLonL ("ground FLIGHT_PARAM 21 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberL ("21 NAVIGATION (.*)")
        String regexGetLatLonF1 ("ground FLIGHT_PARAM 22 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberF1 ("22 NAVIGATION (.*)")
        String regexGetLatLonF2 ("ground FLIGHT_PARAM 23 (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String regexGetBlockNumberF2 ("23 NAVIGATION (.*)")
    	

        // Bindings block changes
    	String regexGetBlockJump("gcs JUMP_TO_BLOCK (\\S*) (\\S*)")




/*
# Out:
# FP_INFO fp_path name lat0 lon0 max_dist_from_home ground_alt security_height alt wp_frame qfu home_mode_height geofence_max_alt geofence_max_height geofence_sector
# FP_WP fp_path name x y lat lon alt height
# FP_WPS_ATTRIB fp_path utm_x0 utm_y0
# FP_EXCEPTION fp_path cond deroute
# FP_SECTOR fp_path name color type list_corners
# TODO variables
# FP_BLOCKS fp_path name no pre_call post_call strip_button strip_icon group key description stage_list[{attrib1_name_stage1:attrib1_stage1,attrib2_name_stage1:attrib2_stage1},{attrib1_name_stage2:attrib1_stage2,...},...]
*/


        String get_fp_info("FP_INFO (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String get_fp_wp("FP_WP (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String get_fp_wps_attrib("FP_WPS_ATTRIB (\\S*) (\\S*) (\\S*)")
        String get_fp_exception("FP_EXCEPTIONS (\\S*) (\\S*) (\\S*)")
        String get_fp_sector("FP_SECTOR (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")
        String get_blocks("FP_BLOCKS (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*) (\\S*)")




        }


LogPrinter test("test")

"machin" =: test.input
bus.in.get_fp_info.[1] => test.input
bus.in.get_fp_wp.[2] => test.input
bus.in.get_fp_sector.[1] => test.input
bus.in.get_blocks.[1] => test.input
        


}