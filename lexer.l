%{

    #include <bits/stdc++.h>
    using namespace std;
    int a = 0;
    vector<string>tokens;
    map<string,string>ma;

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

{let}|{const}|{if}|{else}|{loop}|{stop}|{continue}|{function}|{return}|{print}|{main}|{input}     {printf("\nKEYWORD: %s", yytext);tokens.push_back(strdup(yytext));}

{comment}(.)*{comment}   {printf("\nCOMMENT: %s", yytext);}
\"({identifier}|{number}|{space})*\"     {printf("\nSTRING: %s", yytext);}

{eq}        {printf("\nEQ");tokens.push_back(strdup(yytext));}
{ne}        {printf("\nNE");tokens.push_back(strdup(yytext));}
{lt}        {printf("\nLT");tokens.push_back(strdup(yytext));}
{le}        {printf("\nLE");tokens.push_back(strdup(yytext));}
{gt}        {printf("\nGT");tokens.push_back(strdup(yytext));}
{ge}        {printf("\nGE");tokens.push_back(strdup(yytext));}


{assign}    {printf("\nASSIGN");tokens.push_back(strdup(yytext));}
{incone}    {printf("\nINCONE");tokens.push_back(strdup(yytext));}
{decone}    {printf("\nDECONE");tokens.push_back(strdup(yytext));}
{incassign} {printf("\nINCASSIGN");tokens.push_back(strdup(yytext));}
{decassign} {printf("\nDECASSIGN");tokens.push_back(strdup(yytext));}
{mulassign} {printf("\nMULASSIGN");tokens.push_back(strdup(yytext));}
{divassign} {printf("\nDIVASSIGN");tokens.push_back(strdup(yytext));}


{plus}      {printf("\nPLUS");tokens.push_back(strdup(yytext));}
{minus}     {printf("\nMINUS");tokens.push_back(strdup(yytext));}
{mult}      {printf("\nMULT");tokens.push_back(strdup(yytext));}
{divide}    {printf("\nDIVIDE");tokens.push_back(strdup(yytext));}
{rem}       {printf("\nREM");tokens.push_back(strdup(yytext));}
{bitand}    {printf("\nBITAND");tokens.push_back(strdup(yytext));}
{bitor}     {printf("\nBITOR");tokens.push_back(strdup(yytext));}
{neg}       {printf("\nNEG");tokens.push_back(strdup(yytext));}
{xor}       {printf("\nXOR");tokens.push_back(strdup(yytext));}
{and}       {printf("\nAND");tokens.push_back(strdup(yytext));}
{or}        {printf("\nOR");tokens.push_back(strdup(yytext));}


{lparen}    {printf("\nLPAREN");tokens.push_back(strdup(yytext));}
{rparen}    {printf("\nRPAREN");tokens.push_back(strdup(yytext));}
{lsparen}   {printf("\nLSPAREN");tokens.push_back(strdup(yytext));}
{rsparen}   {printf("\nRSPAREN");tokens.push_back(strdup(yytext));}
{lcparen}   {printf("\nLCPAREN");tokens.push_back(strdup(yytext));}
{rcparen}   {printf("\nRCPAREN");tokens.push_back(strdup(yytext));}



{number}                        {printf("\nNUMBER: %s", yytext); tokens.push_back(strdup(yytext));}
{float}                         {printf("\nFLOAT: %s", yytext); tokens.push_back(strdup(yytext));}
{identifier}                    { printf("\nIDENTIFIER: %s", yytext); tokens.push_back(strdup(yytext)); if(tokens[tokens.size()-2]=="let") ma[tokens[tokens.size()-1]]="name:"+tokens[tokens.size()-1]+";",cout<<"\nIDENTIFIER: "<<ma[tokens[tokens.size()-1]]<<endl;}

{semicol}                       {printf("\nSEMICOL");tokens.push_back(strdup(yytext));}
{space}                         {printf("");} 
\n                              {printf("\n"); tokens.push_back(strdup(yytext));}
\t                              {printf("\t"); tokens.push_back(strdup(yytext));}
 .                              {printf("\n!!!Illegal Token!!!");tokens.push_back(strdup(yytext));}

%%

/* Lexical Analysis: Creates new table entries in the table, example like entries about token. */
int main (int argc, char *argv[]) {
    if(argc > 1){
        FILE *fp = fopen(argv[1], "r");
        if(fp){
            yyin = fp;
        }
    }
    // main function used for running
    yylex();
    
    return 0;
}

int yywrap(){return 0;}
