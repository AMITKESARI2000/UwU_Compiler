# all: lex.yy.c
# 	${CC} lex.yy.c -o lexer
# 

# compiles and runs the main file. on repeated runs, compiles only the updated files
# TARGET: DEPENDENCY
#   <TAB> COMMAND
#
# automatic variables
# $@ = used for target variable
# $< = the 1st prerequisite
# $^ = all of the above prerequisites
#

CC = g++
CCFLAGS = -std=c++17 -g
YACCFLAGS = -v -d -t


parser: y.tab.c lex.yy.c y.tab.h
	${CC} ${CCFLAGS} -w y.tab.c lex.yy.c -o parser

lex.yy.c: lexer.l
	lex lexer.l
y.tab.c: lexer.y
	yacc ${YACCFLAGS} lexer.y

preprocessor: preprocessor.cc parser
	${CC} ${CCFLAGS} $< -o $@

# specifically specifying that these are not file name
.PHONY: all clean

clean:
	rm -rvf *.o *.out *.exe *.uwupre *.uwuir *.asm parser preprocessor y.tab.c lex.yy.c y.tab.h y.output

