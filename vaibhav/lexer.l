%{
    
    #include "y.tab.h"

    int a = 0;
    int lines=0;
    int countn=0;
%}

%option yylineno

let         "let"
const       "const"
if          "if"
else        "else"
loop        "loop"
stop        "stop"
continue    "continue"
function    "function"
return      "return"
print       "print"
main        "main"
input       "input"

eq          "=="
ne          "!="
lt          "<"
le          "<="
gt          ">"
ge          ">="

assign      "="
incone      "++"
decone      "--"
incassign   "+="
decassign   "-="
mulassign   "*="
divassign   "/="

plus        "+"
minus       "-"
mult        "*"
divide      "/"
rem         "%"
bitand      "&"
bitor       "|"
neg         "!"
xor         "^"
and         "&&"
or          "||"

lparen      "("
rparen      ")"
lsparen     "["
rsparen     "]"
lcparen     "{"
rcparen     "}"

comment     "$$"
semicol     ";"
space       " "

digit       [0-9]
number      {digit}+
float       {digit}+\.{digit}+
letter      [A-Za-z]
letter_     [A-Za-z_]
identifier  {letter_}+({digit}|{letter_})*

expr        ({identifier}{relop}{identifier}|{identifier})

%%
{let}       {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return LET;}
{const}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return CONST;}
{if}        {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return IF;}
{else}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return ELSE;}
{loop}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return LOOP;}
{stop}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return STOP;}
{continue}  {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return CONTINUE;}
{function}  {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return FUNCTION;}
{return}    {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return RETURN;}
{print}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return PRINT;}
{main}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return MAIN;}
{input}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  return INPUT;}

{comment}(.|\n)*{comment}                {printf("\nCOMMENT: %s", yytext);}
\"({identifier}|{number}|{space})*\"     {printf("\nSTRING: %s", yytext);  return STRING;}

{eq}        {printf("\nEQ");strcpy(yylval.nd_obj.name,(yytext));  return EQ;}
{lt}        {printf("\nLT");strcpy(yylval.nd_obj.name,(yytext));  return LT;}
{ne}        {printf("\nNE");strcpy(yylval.nd_obj.name,(yytext));  return NE;}
{le}        {printf("\nLE");strcpy(yylval.nd_obj.name,(yytext));  return LE;}
{gt}        {printf("\nGT");strcpy(yylval.nd_obj.name,(yytext));  return GT;}
{ge}        {printf("\nGE");strcpy(yylval.nd_obj.name,(yytext));  return GE;}


{assign}    {printf("\nASSIGN");strcpy(yylval.nd_obj.name,(yytext));     return ASSIGN;}
{incone}    {printf("\nINCONE");strcpy(yylval.nd_obj.name,(yytext));     return INCONE;}
{decone}    {printf("\nDECONE"); strcpy(yylval.nd_obj.name,(yytext));    return DECONE;}
{incassign} {printf("\nINCASSIGN");strcpy(yylval.nd_obj.name,(yytext));  return INCASSIGN;}
{decassign} {printf("\nDECASSIGN");strcpy(yylval.nd_obj.name,(yytext));  return DECASSIGN;}
{mulassign} {printf("\nMULASSIGN");strcpy(yylval.nd_obj.name,(yytext));  return MULASSIGN;}
{divassign} {printf("\nDIVASSIGN");strcpy(yylval.nd_obj.name,(yytext));  return DIVASSIGN;}


{plus}      {printf("\nPLUS");strcpy(yylval.nd_obj.name,(yytext));       return PLUS;}
{minus}     {printf("\nMINUS");strcpy(yylval.nd_obj.name,(yytext));      return MINUS;}
{mult}      {printf("\nMULT");strcpy(yylval.nd_obj.name,(yytext));       return MULT;}
{divide}    {printf("\nDIVIDE");strcpy(yylval.nd_obj.name,(yytext));     return DIVIDE;}
{rem}       {printf("\nREM"); strcpy(yylval.nd_obj.name,(yytext));       return REM;}
{bitand}    {printf("\nBITAND"); strcpy(yylval.nd_obj.name,(yytext));    return BITAND;}
{bitor}     {printf("\nBITOR");  strcpy(yylval.nd_obj.name,(yytext));    return BITOR;}
{neg}       {printf("\nNEG");   strcpy(yylval.nd_obj.name,(yytext));     return NEG;}
{xor}       {printf("\nXOR");   strcpy(yylval.nd_obj.name,(yytext));     return XOR;}
{and}       {printf("\nAND");    strcpy(yylval.nd_obj.name,(yytext));    return AND;}
{or}        {printf("\nOR");     strcpy(yylval.nd_obj.name,(yytext));    return OR;}


{lparen}    {printf("\nLPAREN");strcpy(yylval.nd_obj.name,(yytext));   return LPAREN;}
{rparen}    {printf("\nRPAREN");strcpy(yylval.nd_obj.name,(yytext));   return RPAREN;}
{lsparen}   {printf("\nLSPAREN");strcpy(yylval.nd_obj.name,(yytext));  return LSPAREN;}
{rsparen}   {printf("\nRSPAREN");strcpy(yylval.nd_obj.name,(yytext));  return RSPAREN;}
{lcparen}   {printf("\nLCPAREN");strcpy(yylval.nd_obj.name,(yytext));  return LCPAREN;}
{rcparen}   {printf("\nRCPAREN");strcpy(yylval.nd_obj.name,(yytext));  return RCPAREN;}



{number}                        {printf("\nNUMBER: %s", yytext); strcpy(yylval.nd_obj.name,(yytext));     return NUMBER;}
{float}                         {printf("\nFLOAT: %s", yytext); strcpy(yylval.nd_obj.name,(yytext));      return FLOAT;}
{identifier}                    {printf("\nIDENTIFIER: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));  }

{semicol}                       {printf("\nSEMICOL");  return SEMICOL;}
{space}                         {} 
\n                              {printf("\n"); countn++;}
\t                              {printf("\t"); }
 .                              {printf("\n!!!Illegal Token!!!");}

%%

/* Lexical Analysis: Creates new table entries in the table, example like entries about token. */
// int main (int argc, char *argv[]) {
//     if(argc > 1){
//         FILE *fp = fopen(argv[1], "r");
//         if(fp){
//             yyin = fp;
//         }
//     }
//     // main function used for running
//     yylex();
    
//     return 0;
// }

int yywrap(){return 0;}
