#include "write_csv.h"

void write_gps_coords(string path, vector<vector<double>> coords){
	ofstream myfile (path);

	for (int i = 0 ; i < coords.size(); i ++){
		for (int j = 0; j < coords[i].size(); j ++ ){
			myfile << coords[i][j];
			if(j != coords[i].size() -1){
				myfile << ",";
			}else{
				myfile << endl;
			}
		}
	}

	myfile.close();
}
