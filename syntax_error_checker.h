#pragma once

#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <limits.h>

// function for fiding minimum of three numbers
int min(int a, int b, int c) {
    if (a < b) {
        if (a < c) return a;
        return c;
    } else {
        if (b < c) return b;
        return c;
    }
}

// for finding the minimum edit distance between 2 words
int find_edit_distance(const char a[25], const char b[25]) {
    // removing extra non useable characters
    int m = 0, n = 0;
    while (isalpha(a[m])) m++;
    while (isalpha(b[n])) n++;

    // using dp for finding minimum edit distance
    int dp[m + 1][n + 1];

    for (int i = 0; i <= m; i++) {
        for (int j = 0; j <= n; j++) {
            if (i == 0)
                dp[i][j] = j;
            else if (j == 0)
                dp[i][j] = i;
            else if (a[i - 1] == b[j - 1])
                dp[i][j] = dp[i - 1][j - 1];
            else
                dp[i][j] = 1 + min(dp[i][j - 1],       // Insert
                                   dp[i - 1][j],       // Remove
                                   dp[i - 1][j - 1]);  // Replace
        }
    }

    return dp[m][n];
}

// takes in dict words and tries to find most suitable replacement for the input
// buffer word
void edit_word(char *output, const char *word, int word_size) {
    char dictname[20];
    strcpy(dictname, "./dict.txt");
    int dict_fd = open(dictname, O_RDONLY);
    if (dict_fd == -1) {
        // Erro if no dictionary file
        perror("No dictionary found. Add dict.txt in dir\n");
        exit(1);
    }

    int found = 0;
    int complete_dict_size = 1000000;
    char complete_dict[complete_dict_size];

    read(dict_fd, complete_dict, complete_dict_size);

    char *token = strtok(complete_dict, "\n");

    char input[word_size];
    for (int j = 0; j < word_size; j++) input[j] = 0;  // reset token
    strcpy(input, token);

    int mnm_edit_dis = INT_MAX;
    while (token != NULL) {
        // find min edit distance
        int distance = find_edit_distance(input, word);

        // update the correct word if min edit distance is reduced
        if (mnm_edit_dis > distance) {
            strcpy(output, token);
            mnm_edit_dis = distance;
        }

        // break if exact word found
        if (mnm_edit_dis == 0) break;

        // tokenise next word
        token = strtok(NULL, "\n");

        for (int j = 0; j < word_size; j++) input[j] = 0;  // reset token
        if (token != NULL) strcpy(input, token);
    }

    // close file descriptor
    close(dict_fd);
}

void syntax_error_checker(std::string str) {
    int word_size = 32;
    char word[word_size];
    char correct_word[word_size];
    std::cout << "Found \"" << str << "\"";
    edit_word(correct_word, str.c_str(), word_size);
    std::cout << "Correct:  \"" << correct_word << "\"";

}