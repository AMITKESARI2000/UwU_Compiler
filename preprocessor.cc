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

/**
 * @brief reads src code line by line and replace and adds necessary
 * preprocessor directives
 *
 * @param fout
 * @param SrcCode
 */
void processSrcLine(std::ofstream &fout, std::vector<std::string> &SrcCode) {
    const std::string ADD = "#add";
    const std::string DEFINE = "#define";
    const std::string SEPERATOR = "::";

    std::map<std::string, std::string> defineDict;

    for (int i = 0; i < SrcCode.size(); i++) {
        std::string line = SrcCode[i];

        // search for #add import statement
        auto pos1 = line.find(ADD);
        auto pos2 = line.find(DEFINE);

        if (pos1 != std::string::npos) {
            // #add import statement found. Add all the code from header in
            // the preprocessed file

            // extract header name
            std::string headerFileName;
            int lpos = 0, rpos = line.size() - 1;
            for (; line[lpos] != '<'; lpos++)
                ;
            for (; line[rpos] != '>'; rpos--)
                ;
            lpos++;
            headerFileName = line.substr(lpos, rpos - lpos);
            std::cout << "\n Adding header-> " << headerFileName << std::endl;

            // dump all header code
            std::ifstream fin;
            fin.open(headerFileName, std::ios::in);

            if (!fin) {
                std::cout << "\nW: Unable to include header file ( " +
                                 headerFileName +
                                 " not found). Please include correct path "
                                 "from current working directory."
                          << std::endl;
                // std::filesystem::path cwd = std::filesystem::current_path() /
                // "filename.txt"; std::cout << "\nfilepath: " << cwd.string()
                // << std::endl;
                continue;
            }
            std::string tmpline;
            while (std::getline(fin, tmpline)) {
                // std::cout << "HEADER:::: "<<line << std::endl;
                fout << tmpline;
            }
            fout << std::endl;
            fin.close();

            // since #add import preprocessor line is not required in src code.
            SrcCode.erase(SrcCode.begin());
            i--;

        } else if (pos2 != std::string::npos) {
            // found a #define pp::print line
            auto seperatorPos = line.find(SEPERATOR);
            if (seperatorPos == std::string::npos) {
                std::cout << "Wrong syntax. Use #define VARNAME1::VARNAME2"
                          << std::endl;
                exit(EXIT_FAILURE);
            }

            // get VAR1 and VAR2
            std::string var1 = "";
            std::string var2 = line.substr(seperatorPos + 2);

            for (int i = seperatorPos - 1; line[i] != ' '; i--) {
                var1 += line[i];
            }
            std::reverse(var1.begin(), var1.end());

            // std::cout << var1 << "::" << var2 << std::endl;
            // store in a dictionary for replacing in the program
            defineDict[var1] = var2;

        } else {
            // convert #define using defineDict if found in that line
            for (auto wordMeaning : defineDict) {
                // find in dictionary for particular word
                auto replacePos = line.find(wordMeaning.first);
                if (replacePos != std::string::npos) {
                    std::cout << " Replaced " << wordMeaning.first << " -> "
                              << wordMeaning.second << std::endl;

                    // cut before and after part, join and replace with the new
                    // word in middle
                    std::string prefix = line.substr(0, replacePos);
                    std::string suffix =
                        line.substr(replacePos + wordMeaning.first.size());

                    line = prefix + wordMeaning.second + suffix;
                    // std::cout << "NEW LINE|" << line << "|" << std::endl;
                    break;
                }
            }
            fout << line;
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
    std::string dataOpFilename = dataIpFilename + "pre";

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
    // for (auto line : SrcCode) std::cout << "SC--->" << line << std::endl;
    std::cout << "-------------------------" << std::endl;

    std::cout << std::endl;
    std::cout << "Preprocessed file generated at: " + dataOpFilename
              << std::endl;
    fout.close();
    return 0;
}