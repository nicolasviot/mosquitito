#include "download.h"
#include <iostream>
#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <curl/curl.h>
#include <limits>
#include <stdlib.h>
using namespace std;
//check version of file system
#ifndef __has_include
static_assert(false, "__has_include not supported");
#else
#  if __has_include(<filesystem>)
#    include <filesystem>
namespace filesystem = filesystem;
#  elif __has_include(<experimental/filesystem>)
#    include <experimental/filesystem>
namespace filesystem = experimental::filesystem;
#  elif __has_include(<boost/filesystem.hpp>)
#    include <boost/filesystem.hpp>
namespace filesystem = boost::filesystem;
#  endif
#endif
#include <regex>



size_t write_data(void* ptr, size_t size, size_t nmemb, FILE* stream)
{
    size_t written;
    written = fwrite(ptr, size, nmemb, stream);
    return written;
}

int download(string path)
{
	if(!filesystem::exists(path)){
		CURL* curl;
	    FILE* fp;
	    CURLcode res;
	    string url_end;
	    regex rgx_url_end(".*/cache/(.*)");
	    smatch match_url;
	    if(regex_search(path, match_url, rgx_url_end)){
	    	url_end = match_url[1];
	    }else{
	        cout << "PARSE  ERROR" << endl;
	        return -1;
	    } 
	    // the url can be changed here if another server is used. 
	    //if this url is not working try to modify the "a.tile" with "b.tile" or "c.tile" in the next url
	    string url = "http://a.tile.openstreetmap.fr/"+url_end;
	    string directory;
	    regex rgx("(.*)/.*.png");
	    smatch match;
	    if(regex_search(path, match, rgx)){
	    	directory = match[1];
	    	filesystem::create_directories(directory);
	    }else{
	        cout << "PARSE  ERROR" << endl;
	        return -1;
	    }
	    curl = curl_easy_init();
	    if (curl)
	    {
	    	// cout << "Téléchargement de Tiles : " << path <<  endl;
	        fp = fopen(path.c_str(), "wb");
	        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
	        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
	        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
	        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
	        res = curl_easy_perform(curl);
	        /* always cleanup */
	        curl_easy_cleanup(curl);
	        fclose(fp);
	    }
	    return 0;
	}
	else
	{
		return 0;
	}
}

void delete_image(string path){
	if(filesystem::exists(path)){
		filesystem::remove(path);
	}
}


