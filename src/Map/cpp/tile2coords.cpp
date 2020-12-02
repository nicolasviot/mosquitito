#include "tile2coords.h"
#include <iostream>
#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <limits>
#include <stdlib.h>
#include <regex>


using namespace std;


//those function have been made in Smala but are needed in this format for the initialisation of the map

int long2tilex(double lon, int z)
{
	return (int)(floor((lon + 180.0) / 360.0 * (1 << z)));
}

int lat2tiley(double lat, int z)
{
    double latrad = lat * M_PI/180.0;
	return (int)(floor((1.0 - asinh(tan(latrad)) / M_PI) / 2.0 * (1 << z)));
}

double tilex2long(int x, int z)
{
	return (long double) x / (long double)(1 << z) * 360.0 - 180;
}

double tiley2lat(int y, int z)
{
	long double n = M_PI - 2.0 * M_PI * y / (long double)(1 << z);
	return (long double) 180.0 / M_PI * atan(0.5 * (exp(n) - exp(-n)));
} 


int parseZ(string path){
	regex rgx1(".*/cache/.*/(.*)/.*/.*");
    smatch match1;
    if(regex_search(path, match1, rgx1)){
    	int z = (int)stoi(match1[1]);
		return z;
    }else{
        cout << "PARSE Z ERROR "  << path << endl;
        return -1;
    }
}

int parseX(string path){
	regex rgx(".*/cache/.*/.*/(.*)/.*");
    smatch match;
    if(regex_search(path, match, rgx)){
    	int x = (int)stoi(match[1]);
		return x;
    }else{
        cout << "PARSE X ERROR" << endl;
        return -1;
    }
}
int parseY(string path){
	regex rgx(".*/cache/.*/.*/.*/(.*).png");
    smatch match;
    if(regex_search(path, match, rgx)){
    	int y = (int)stoi(match[1]);
		return y;
    }else{
        cout << "PARSE Y ERROR" << endl;
        return -1;
    }
}



string format_cache(int z, int x, int y, string tileSource){
    if(tileSource.compare("Uni")== 0){
        return "./cache/hot/"+to_string(z)+"/"+to_string(x)+"/"+to_string(y)+".png";
    }else if(tileSource.compare("FR")==0){
        return "./cache/osmfr/"+to_string(z)+"/"+to_string(x)+"/"+to_string(y)+".png";
    }else {
        cout << "Error with tileSource" << endl;
        return "";
    }
	
}

int mod_function(int value, int div){
    int res =  value % div;
	return (res >= 0)? res : div + value; 
}