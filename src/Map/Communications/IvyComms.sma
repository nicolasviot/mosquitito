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
        }



}