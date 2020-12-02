#ifndef TILE2COORDS_H
#define TILE2COORDS_H

#include <iostream> 
#include <string>
using namespace std;

int long2tilex(double lon, int z);


int lat2tiley(double lat, int z);


double tilex2long(int x, int z);


double tiley2lat(int y, int z);

int parseZ(string path);

int parseX(string path);

int parseY(string path);

string format_cache(int z, int x, int y,string tileSource);

int mod_function(int value, int div);

#endif
