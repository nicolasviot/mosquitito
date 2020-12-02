/*
#include "read_csv.h"

#define macro "jobs"
vector<vector<double>> get_path_data(string path){

	ifstream myfile (path);
	if(!myfile.is_open()) throw runtime_error("Could not open file");
	vector<vector<double>> res;
	string line, word, temp;

	while (getline(myfile,line)){

		stringstream s (line); 

		vector<double> row;
		row.clear();

		while (getline(s,word,',')){
			row.push_back(stod(word));
		}
		res.push_back(row);
	}
	myfile.close();
	return res;
}

vector<double> get_path_data_by_line(string path, int wanted_line){

	ifstream myfile (path);

	int num_line = 0; 

	if(!myfile.is_open()) throw runtime_error("Could not open file");

	vector<double> res;
	string line, word, temp;

	while (getline(myfile,line) || num_line < wanted_line){

		if(num_line == wanted_line) {
			stringstream s (line); 
			while (getline(s,word,',')){
				res.push_back(stod(word));
			}
		}
		num_line ++;
	}
	myfile.close();
	if(res.size() == 0){
		res.push_back(0);
		res.push_back(0);
		res.push_back(0);
		res.push_back(0);
		cout << "end" << endl;
	}
	return res;
}
*/