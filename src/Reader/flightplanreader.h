
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>
#include <sstream>
using namespace std;



class Block{
	string name;
	int id;
	public :
		string get_name(void);
		int get_id(void);
}


vector<Block> get_block(string);

#endif