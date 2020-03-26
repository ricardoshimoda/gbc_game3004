// Changer.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <string>
#include <iostream>
#include <filesystem>

using namespace std;
namespace fs = std::filesystem;

void changeFileName(string path, string relativePath) {
	for (const auto & entry : fs::directory_iterator(path)) {
		std::cout << "Analyzing: " << entry.path().string() << std::endl;
		string subPath = entry.path().stem().string();
		if (entry.is_directory()) {
			std::cout << "Going now to: " << relativePath + "_" + subPath << std::endl;
			changeFileName(entry.path().string(), relativePath + "_" + subPath);
		}
		else if (entry.is_regular_file()) {
			string currentFile = entry.path().string();
			const size_t last_slash_idx = currentFile.find_last_of("\\/");
			if (std::string::npos != last_slash_idx)
			{
				currentFile.erase(0, last_slash_idx + 1);
			}
			std::cout << "Renaming from: " << entry.path().string() << " to " << (path + "\\" +relativePath + "_" + currentFile) << std::endl;
			std::rename(entry.path().string().c_str(), (path + "\\" + relativePath + "_" + currentFile).c_str());
		}
	}
}

int main(int argc, char **argv)
{
	if (argc < 2) {
		cout << "usage: changer <root_directory_of_changes>" << endl;
		return -1;
	}
	string path = argv[1];
	
	for (const auto & entry : fs::directory_iterator(path)) {
		//subPath = subPath.substr(path.size);
		if (entry.is_directory()) {
			string subPath = entry.path().stem().string();
			changeFileName(entry.path().string(), subPath);
		}
	}

	return 0;
}



