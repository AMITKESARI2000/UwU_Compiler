%{
  #include<stdio.h>
  #include<stdlib.h>
  

  extern FILE * yyin;

  int yylex();
  int yyerror(char *);

%}

%token LET CONST IF ELSE LOOP STOP CONTINUE FUNCTION RETURN PRINT MAIN INPUT STRING EQ 
%token LT NE LE GT GE ASSIGN INCONE DECONE INCASSIGN DECASSIGN MULASSIGN DIVASSIGN PLUS 
%token MINUS MULT DIVIDE REM BITAND BITOR NEG XOR AND OR LPAREN RPAREN LSPAREN RSPAREN 
%token LCPAREN RCPAREN NUMBER FLOAT IDENTIFIER SEMICOL COMMA
%%

stment_seq: STATEMENT | stment_seq STATEMENT ;

ARRAY:
ARRAY LSPAREN IDENTIFIER RSPAREN |
ARRAY LSPAREN NUMBER RSPAREN |
IDENTIFIER LSPAREN IDENTIFIER RSPAREN |
IDENTIFIER LSPAREN NUMBER RSPAREN;


VARIABLES: 
IDENTIFIER |
NUMBER |
STRING |
FLOAT |
ARRAY;

PARAMS:
PARAMS COMMA VARIABLES |
EXPR |
FUNCTIONCALL |
;

EXPR:
LPAREN EXPR RPAREN |
EXPR PLUS VARIABLES |
EXPR PLUS FUNCTIONCALL |
EXPR MINUS VARIABLES |
EXPR MINUS FUNCTIONCALL |
EXPR MULT VARIABLES |
EXPR MULT FUNCTIONCALL |
EXPR DIVIDE VARIABLES |
EXPR DIVIDE FUNCTIONCALL |
EXPR REM VARIABLES |
EXPR REM FUNCTIONCALL |
EXPR BITAND VARIABLES |
EXPR BITAND FUNCTIONCALL |
EXPR BITOR VARIABLES |
EXPR BITOR FUNCTIONCALL |
EXPR XOR VARIABLES |
EXPR XOR FUNCTIONCALL |
VARIABLES |
IDENTIFIER INCONE |
IDENTIFIER DECONE;

BOOLEANS:
EXPR EQ VARIABLES |
EXPR NE VARIABLES |
EXPR LT VARIABLES |
EXPR LE VARIABLES |
EXPR GT VARIABLES |
EXPR GE VARIABLES 
;

CONDITION:
LPAREN CONDITION RPAREN |
CONDITION AND BOOLEANS |
CONDITION OR BOOLEANS |
CONDITION XOR BOOLEANS |
BOOLEANS |
NEG BOOLEANS
;

CONDITIONAL_STAMENT:
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN |
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE LCPAREN stment_seq RCPAREN |
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE CONDITIONAL_STAMENT;

FUNCTIONCALL:
IDENTIFIER LPAREN PARAMS RPAREN |
MAIN LPAREN PARAMS RPAREN;

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN;


Loop:
LOOP LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN IDENTIFIER ASSIGN EXPR RPAREN |
LOOP LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN IDENTIFIER INCONE RPAREN |
LOOP LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN IDENTIFIER DECONE RPAREN;


STATEMENT:
LET IDENTIFIER ASSIGN EXPR SEMICOL |
CONST IDENTIFIER ASSIGN EXPR SEMICOL |
LET IDENTIFIER SEMICOL |
LET ARRAY SEMICOL |
IDENTIFIER ASSIGN EXPR SEMICOL |
IDENTIFIER INCASSIGN VARIABLES SEMICOL |
IDENTIFIER DECASSIGN VARIABLES SEMICOL |
IDENTIFIER INCONE SEMICOL |
IDENTIFIER DECONE SEMICOL |
ARRAY ASSIGN EXPR SEMICOL |
ARRAY INCASSIGN VARIABLES SEMICOL |
ARRAY DECASSIGN VARIABLES SEMICOL |
ARRAY INCONE SEMICOL |
ARRAY DECONE SEMICOL |
PRINT LPAREN EXPR RPAREN SEMICOL |
PRINT LPAREN FUNCTIONCALL RPAREN SEMICOL |
INPUT LPAREN IDENTIFIER RPAREN SEMICOL |
CONDITIONAL_STAMENT |
Loop |
RETURN EXPR SEMICOL|
FUNCTIONCALL SEMICOL |
FUNCTIONDEF |
STOP SEMICOL|
CONTINUE SEMICOL;

%%

int main(int argc, char *argv[])
{
   if (argc != 2) {
       printf("\nUsage: <exefile> <inputfile>\n\n");
       exit(0);
   }
   yyin = fopen(argv[1], "r");
  yyparse();

}
int yyerror(char *s){
  printf("\n\nError: %s\n", s);
}