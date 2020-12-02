#ifndef WRITE_CSV_H
#define WRITE_CSV_H
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>
#include <sstream>
#include <ctime>
using namespace std;

void write_gps_coords(string path, vector<vector<double>> coords);

#endif