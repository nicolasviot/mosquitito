#include "map_.h"
#include <iostream>
#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <limits>
#include <stdlib.h>




int begin_x (int z,double longitude, int column){

	int begin = (int) (column/2); 
	if(column%2 == 0){
		return long2tilex(longitude,z) - begin + 1;
	}else{
		return long2tilex(longitude,z) - begin;
	}
	
}

int end_x (int z, double longitude, int column){
	int end = (int) (column/2); 
	return (long2tilex(longitude,z) + end);
}

int begin_y (int z, double latitude, int row){
	int begin = (int) (row/2);
	if(row%2 == 0 ){
		return lat2tiley(latitude,z) - begin + 1;
	}else{
		return lat2tiley(latitude,z) - begin;
	}
	
}

int end_y (int z, double latitude, int row){
	int end = (int) (row/2);
	return lat2tiley(latitude,z) + end;
}

int begin_x_pointed (int z,double longitude, int num_tile,int row)
{
  int num_column = (num_tile -1)/row;
  return long2tilex(longitude,z) - num_column;
}

int end_x_pointed (int z, double longitude,int num_tile,int row,int column)
{
  int num_column = column - 1 - (num_tile-1)/row;
  return long2tilex(longitude,z) + num_column;
}

int begin_y_pointed(int z, double latitude,int num_tile,int row)
{
  int num_row;
  num_row = (num_tile%row == 0 )? row : num_tile%row ;
  return lat2tiley(latitude,z) - num_row +1;
}

int end_y_pointed (int z, double latitude,int num_tile,int row)
{
  int num_row;
  num_row = (num_tile%row == 0 )? 0 :  row - num_tile%row ;
  return lat2tiley(latitude,z) + num_row ;
}

int mod_func(int value, int div){
	int res =  value % div;
	return (res >= 0)? res : div + value; 
}
