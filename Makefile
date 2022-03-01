# compiles and runs the main file. on repeated runs, compiles only the updated files
# TARGET: DEPENDENCY
#   <TAB> COMMAND
#
# automatic variables
# $@ = used for target variable
# $< = the 1st prerequisite
# $^ = all of the above prerequisites
#

# CC = g++
# CCFLAGS = -std=c++17 -Wall -g
# 
# all: lex.yy.c
# 	${CC} lex.yy.c -o lexer
# 
# lex.yy.c: lexer.l
# 	lex $<
# 
# .PHONY: all clean
# 	# specifically specifying that these are not file name
# clean:
# 	rm -rvf *.o *.out *.exe lexer lex.yy.c

# compiles and runs the main file. on repeated runs, compiles only the updated files
# TARGET: DEPENDENCY
#   <TAB> COMMAND
#
# automatic variables
# $@ = used for target variable
# $< = the 1st prerequisite
# $^ = all of the above prerequisites
#

parser: y.tab.c lex.yy.c y.tab.h
	g++ -w y.tab.c lex.yy.c -g -o parser
lex.yy.c: lexer.l
	lex lexer.l
y.tab.c: lexer.y
	yacc -v -d -t lexer.y
clean:
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output

