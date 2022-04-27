/**
 * @file preprocessor.cc
 * @author Amit Kesari, Aditya Sharma, Vaibhav Gelle
 * @brief Preprocess source code
 *        #add <filename>; // import statement
 *        #define VARNAME1::VARNAME2;  // change varname1 to varname2
          directives and generate next stage file with extension ".uwupre"
          containing all the consolidated code.
 * @version 0.1
 * @date 2022-03-06
 *
 * @copyright Copyright (c) 2022
 *
 */

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

using namespace std;

/**
 * @brief reads src code line by line and replace and adds necessary
 * preprocessor directives
 *
 * @param fout
 * @param SrcCode
 */
void processSrcLine(std::ofstream &fout, std::vector<std::string> &SrcCode) {
  vector<string> data_seg;
    for (auto i : SrcCode) {
        if (i != "") {
            int found = i.find("_i");
            if (found != std::string::npos){
              found += 3;
              string var_name = "";
              string value_name = "";
              while (found<i.size() && i[found] != ' ' && i[found] != '\n') {
                  var_name += i[found];
                  found++;
              }
              found ++;
              while (found < i.size() && i[found] != ' ' && i[found] != '\n') {
                  value_name += i[found];
                  found++;
              }
              value_name = "";
              found += 2;
              while (found < i.size() && i[found] != ' ' && i[found] != '\n') {
                  value_name += i[found];
                  found++;
              }
              std::cout << "Next occurrence is :" << var_name << " " << value_name << std::endl;
            }
            std::cout << i << std::endl;
        }
    }
}

int main(int argc, char **argv) {
    // Take input from command line
    if (argc < 2 || argc >= 3) {
        std::cout << "Format is ./preprocessor <programFilename>" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::string dataIpFilename = argv[1];
    // std::string dataOpFilename = dataIpFilename + "pre";
    std::string dataOpFilename = "output.asm";

    std::ifstream fin;
    std::ofstream fout;

    // file directives
    fin.open(dataIpFilename, std::ios::in);
    fout.open(dataOpFilename, std::ios::out);
    if (!fin) {
        std::cout << "File not found. Exiting" << std::endl;
        exit(EXIT_FAILURE);
    }
    if (fout) {
        std::cout << "Removing Earlier Traces." << std::endl;
        // TODO: clear file if not already
    }

    // get complete src code from UwU pgm
    std::string line;
    std::vector<std::string> SrcCode;
    while (std::getline(fin, line)) {
        SrcCode.push_back(line);
    }
    fin.close();

    std::cout << "\n-------------------------" << std::endl;
    processSrcLine(fout, SrcCode);
    fout << "@@@";
    // for (auto line : SrcCode) std::cout << "SC--->" << line << std::endl;
    std::cout << "-------------------------" << std::endl;

    std::cout << std::endl;
    std::cout << "Preprocessed file generated at: " + dataOpFilename
              << std::endl;
    fout.close();
    return 0;
}