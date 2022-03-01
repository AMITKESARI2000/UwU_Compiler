%{
  #include<stdio.h>
  #include<stdlib.h>
  

  extern FILE * yyin;

  int yylex();
  int yyerror(char *);

%}

%token LET CONST IF ELSE LOOP STOP CONTINUE FUNCTION RETURN PRINT MAIN INPUT STRING EQ LT NE LE GT GE ASSIGN INCONE DECONE INCASSIGN DECASSIGN MULASSIGN DIVASSIGN PLUS MINUS MULT DIVIDE REM BITAND BITOR NEG XOR AND OR LPAREN RPAREN LSPAREN RSPAREN LCPAREN RCPAREN NUMBER FLOAT IDENTIFIER SEMICOL
%%

stment_seq: STATEMENT | stment_seq STATEMENT ;

PARAMS:
PARAMS SEMICOL IDENTIFIER |
PARAMS SEMICOL NUMBER |
IDENTIFIER |
NUMBER |
EXPR |
;

CONDITIONAL_STAMENT:
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN |
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE CONDITIONAL_STAMENT;

FUNCTIONCALL:
IDENTIFIER LPAREN PARAMS RPAREN |
MAIN LPAREN PARAMS RPAREN;

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN;

CONDITION:
LPAREN CONDITION RPAREN |
CONDITION AND CONDITION |
CONDITION OR CONDITION |
EXPR EQ EXPR |
EXPR NE EXPR |
EXPR LT EXPR |
EXPR LE EXPR |
EXPR GT EXPR |
EXPR GE EXPR |
;

EXPR:
EXPR PLUS NUMBER |
EXPR PLUS IDENTIFIER |
EXPR PLUS FLOAT |
EXPR PLUS FUNCTIONCALL |
EXPR MINUS NUMBER |
EXPR MINUS IDENTIFIER |
EXPR MINUS FLOAT |
EXPR MINUS FUNCTIONCALL |
EXPR MULT NUMBER |
EXPR MULT IDENTIFIER |
EXPR MULT FLOAT |
EXPR MULT FUNCTIONCALL |
EXPR DIVIDE NUMBER |
EXPR DIVIDE IDENTIFIER |
EXPR DIVIDE FLOAT |
EXPR DIVIDE FUNCTIONCALL |
EXPR REM NUMBER |
EXPR REM IDENTIFIER |
EXPR REM FLOAT |
EXPR REM FUNCTIONCALL |
EXPR BITAND IDENTIFIER |
EXPR BITAND NUMBER |
EXPR BITOR IDENTIFIER |
EXPR BITOR NUMBER |
EXPR XOR IDENTIFIER |
EXPR XOR NUMBER |
IDENTIFIER |
NUMBER |
STRING |
IDENTIFIER INCONE |
IDENTIFIER DECONE |
;

Loop:
LOOP LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN EXPR RPAREN ;


STATEMENT:
LET IDENTIFIER ASSIGN EXPR SEMICOL |
CONST IDENTIFIER ASSIGN EXPR SEMICOL |
LET IDENTIFIER SEMICOL |
IDENTIFIER ASSIGN EXPR SEMICOL |
IDENTIFIER INCASSIGN NUMBER SEMICOL |
IDENTIFIER INCASSIGN IDENTIFIER SEMICOL |
IDENTIFIER DECASSIGN NUMBER SEMICOL |
IDENTIFIER DECASSIGN IDENTIFIER SEMICOL |
IDENTIFIER INCONE SEMICOL |
IDENTIFIER DECONE SEMICOL |
PRINT LPAREN IDENTIFIER RPAREN SEMICOL |
PRINT LPAREN STRING RPAREN SEMICOL |
PRINT LPAREN FUNCTIONCALL RPAREN SEMICOL |
CONDITIONAL_STAMENT |
Loop |
RETURN EXPR SEMICOL|
FUNCTIONCALL SEMICOL |
FUNCTIONDEF |
STOP SEMICOL|
CONTINUE SEMICOL|
INPUT LPAREN IDENTIFIER RPAREN SEMICOL;

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