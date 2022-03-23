%{
    #include "y.tab.h"
    #include<map>
    #include<vector>
    #include<string>
    #include<iostream>

    using namespace std;
    int a = 0;
    int lines=0;
    vector<string> tokens;
    map<string,string> ma;
%}
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

comment_start     "$*"
comment_end     "*$"
semicol     ";"
comma       ","
space       " "

digit       [0-9]
number      {digit}+
float       {digit}+\.{digit}+
letter      [A-Za-z]
letter_     [A-Za-z_]
identifier  {letter_}+({digit}|{letter_})*

expr        ({identifier}{relop}{identifier}|{identifier})

%%
{let}       {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return LET;}
{const}     {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return CONST;}
{if}        {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return IF;}
{else}      {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return ELSE;}
{loop}      {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return LOOP;}
{stop}      {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return STOP;}
{continue}  {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return CONTINUE;}
{function}  {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return FUNCTION;}
{return}    {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return RETURN;}
{print}     {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return PRINT;}
{main}      {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return MAIN;}
{input}     {printf("\nKEYWORD: %s", yytext); tokens.push_back(strdup(yytext)); return INPUT;}

{comment_start}([^*]|\*+[^*$])*{comment_end}      {printf("\nCOMMENT: %s", yytext);}
\"(\\.|[^"\\])*\"                                 {printf("\nSTRING: %s", yytext); tokens.push_back(strdup(yytext)); return STRING;}
\'(\\.|[^'\\])*\'                                 {printf("\nSTRING: %s", yytext); tokens.push_back(strdup(yytext)); return STRING;}

{eq}        {printf("\nEQ"); tokens.push_back(strdup(yytext)); return EQ;}
{lt}        {printf("\nLT"); tokens.push_back(strdup(yytext)); return LT;}
{ne}        {printf("\nNE"); tokens.push_back(strdup(yytext)); return NE;}
{le}        {printf("\nLE"); tokens.push_back(strdup(yytext)); return LE;}
{gt}        {printf("\nGT"); tokens.push_back(strdup(yytext)); return GT;}
{ge}        {printf("\nGE"); tokens.push_back(strdup(yytext)); return GE;}


{assign}    {printf("\nASSIGN");    tokens.push_back(strdup(yytext)); return ASSIGN;}
{incone}    {printf("\nINCONE");    tokens.push_back(strdup(yytext)); return INCONE;}
{decone}    {printf("\nDECONE");    tokens.push_back(strdup(yytext)); return DECONE;}
{incassign} {printf("\nINCASSIGN"); tokens.push_back(strdup(yytext)); return INCASSIGN;}
{decassign} {printf("\nDECASSIGN"); tokens.push_back(strdup(yytext)); return DECASSIGN;}
{mulassign} {printf("\nMULASSIGN"); tokens.push_back(strdup(yytext)); return MULASSIGN;}
{divassign} {printf("\nDIVASSIGN"); tokens.push_back(strdup(yytext)); return DIVASSIGN;}


{plus}      {printf("\nPLUS");      tokens.push_back(strdup(yytext)); return PLUS;}
{minus}     {printf("\nMINUS");     tokens.push_back(strdup(yytext)); return MINUS;}
{mult}      {printf("\nMULT");      tokens.push_back(strdup(yytext)); return MULT;}
{divide}    {printf("\nDIVIDE");    tokens.push_back(strdup(yytext)); return DIVIDE;}
{rem}       {printf("\nREM");       tokens.push_back(strdup(yytext)); return REM;}
{bitand}    {printf("\nBITAND");    tokens.push_back(strdup(yytext)); return BITAND;}
{bitor}     {printf("\nBITOR");     tokens.push_back(strdup(yytext)); return BITOR;}
{neg}       {printf("\nNEG");       tokens.push_back(strdup(yytext)); return NEG;}
{xor}       {printf("\nXOR");       tokens.push_back(strdup(yytext)); return XOR;}
{and}       {printf("\nAND");       tokens.push_back(strdup(yytext)); return AND;}
{or}        {printf("\nOR");        tokens.push_back(strdup(yytext)); return OR;}


{lparen}    {printf("\nLPAREN");  tokens.push_back(strdup(yytext)); return LPAREN;}
{rparen}    {printf("\nRPAREN");  tokens.push_back(strdup(yytext)); return RPAREN;}
{lsparen}   {printf("\nLSPAREN"); tokens.push_back(strdup(yytext)); return LSPAREN;}
{rsparen}   {printf("\nRSPAREN"); tokens.push_back(strdup(yytext)); return RSPAREN;}
{lcparen}   {printf("\nLCPAREN"); tokens.push_back(strdup(yytext)); return LCPAREN;}
{rcparen}   {printf("\nRCPAREN"); tokens.push_back(strdup(yytext)); return RCPAREN;}



{number}                        {printf("\nNUMBER: %s", yytext);     tokens.push_back(strdup(yytext)); return NUMBER;}
{float}                         {printf("\nFLOAT: %s", yytext);      tokens.push_back(strdup(yytext)); return FLOAT;}
{identifier}                    {
                                    printf("\nIDENTIFIER: %s", yytext); 
                                    tokens.push_back(strdup(yytext)); 
                                    if(tokens[tokens.size()-2]=="let"){
                                        ma[tokens[tokens.size()-1]]="name:"+tokens[tokens.size()-1]+";"+"scope: "+to_string(lines)+";";
                                        cout<<"\nIDENTIFIER: "<<ma[tokens[tokens.size()-1]]<<endl; 
                                    }
                                    return IDENTIFIER;
                                }

{comma}                         {printf("\nCOMMA"); tokens.push_back(strdup(yytext)); return COMMA;}
{semicol}                       {printf("\nSEMICOL"); tokens.push_back(strdup(yytext)); return SEMICOL;}
{space}                         {} 
\n|\r                              {printf("\n"); lines++;}
\t                              {printf("\t"); }
 .                              {printf("\n!!!Illegal Token!!!");}

%%


int yywrap(){return 0;}
