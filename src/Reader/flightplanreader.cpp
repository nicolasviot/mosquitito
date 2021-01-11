
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>
#include <sstream>
class Block{
	std::string name;
	int id;
	public :
		Block(std::string, int);
		std::string get_name(void){return name;};
		int get_id(void){return id;};
};


Block::Block(std::string _name, int _id){
	name = _name;
	id = _id;
};

std::vector<Block> get_block(std::string path){
	std::ifstream myfile (path);
	if (!myfile.is_open()) throw std::runtime_error("Could not open file");
	std::vector<Block> res;

	std::string line, word, blank, sep;
	blank = " ";
	sep = ":";
	while (getline(myfile, line)){
		
		int npos = line.find(blank);
		std::string left = line.substr(0, npos);
		std::string right = line.substr(npos +1, std::string::npos);



		std::string Name, Id;

		int nposl = left.find(sep);
		int nposr = right.find(sep);

		Name = left.substr(nposl + 1, std::string::npos);
		Id = left.substr(nposr +1, std::string::npos);
		res.push_back(Block(Name, std::stoi(Id)));		
	}
	return res;


}