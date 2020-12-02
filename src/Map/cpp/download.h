#ifndef DOWNLOAD_H
#define DOWNLOAD_H
#include <iostream> 
#include <string>
using namespace std;

size_t write_data(void* ptr, size_t size, size_t nmemb, FILE* stream);


int download(string path);

void delete_image(string path);

#endif

