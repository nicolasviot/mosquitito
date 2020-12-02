#ifndef READ_CSV_H
#define READ_CSV_H
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>
#include <sstream>
using namespace std;

vector<vector<double>> get_path_data(string path);

vector<double> get_path_data_by_line(string path, int wanted_line);

#endif