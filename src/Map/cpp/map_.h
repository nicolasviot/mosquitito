#ifndef MAP_H
#define MAP_H
#include <iostream> 
#include <string>
#include "tile2coords.h"
using namespace std;
int begin_x (int z,double longitude, int column);

int end_x (int z, double longitude, int column);

int begin_y (int z, double latitude, int row);

int end_y (int z, double latitude, int row);

int begin_x_pointed (int z,double longitude, int num_tile,int row);

int end_x_pointed (int z, double longitude,int num_tile,int row,int column);

int begin_y_pointed(int z, double latitude,int num_tile,int row);

int end_y_pointed (int z, double latitude,int num_tile,int row);

int mod_func(int value, int div);

#endif
