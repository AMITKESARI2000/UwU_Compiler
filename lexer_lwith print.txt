%{
    
    #include "y.tab.h"
    #include<map>
    #include<vector>
    #include<string>
    #include<iostream>

    using namespace std;
    int a = 0;
    int lines=1;
    string curr_function="main";
    vector<string> tokens;
    map<string,string> ma;

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

comment_start   "$*"
comment_end     "*$"
semicol         ";"
comma           ","
space           " "

digit       [0-9]
number      {digit}+
float       {digit}+\.{digit}+
letter      [A-Za-z]
letter_     [A-Za-z_]
identifier  {letter_}+({digit}|{letter_})*

expr        ({identifier}{relop}{identifier}|{identifier})

%%
{let}       {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LET;}
{const}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return CONST;}
{if}        {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return IF;}
{else}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return ELSE;}
{loop}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LOOP;}
{stop}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return STOP;}
{continue}  {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return CONTINUE;}
{function}  {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return FUNCTION;}
{return}    {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RETURN;}
{print}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return PRINT;}
{main}      {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  
                                        curr_function = strdup(yytext); 
                                        cout << "\nNAME OF FUNCTION: " << curr_function<< endl; return MAIN;}
{input}     {printf("\nKEYWORD: %s", yytext);strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return INPUT;}

{comment_start}([^*]|\*+[^*$])*{comment_end}                {printf("\nCOMMENT: %s", yytext);string s = strdup(yytext); for(int i=0;i<s.size();i++){if(s[i]=='\n')lines++;} }
\"(\\.|[^"\\])*\"     {printf("\nSTRING: %s", yytext);tokens.push_back(strdup(yytext));  return STRING;}
\'(\\.|[^'\\])*\'     {printf("\nSTRING: %s", yytext);tokens.push_back(strdup(yytext));  return STRING;}

{eq}        {printf("\nEQ");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return EQ;}
{lt}        {printf("\nLT");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LT;}
{ne}        {printf("\nNE");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return NE;}
{le}        {printf("\nLE");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LE;}
{gt}        {printf("\nGT");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return GT;}
{ge}        {printf("\nGE");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return GE;}


{assign}    {printf("\nASSIGN");   strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return ASSIGN;}
{incone}    {printf("\nINCONE");   strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return INCONE;}
{decone}    {printf("\nDECONE");   strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return DECONE;}
{incassign} {printf("\nINCASSIGN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return INCASSIGN;}
{decassign} {printf("\nDECASSIGN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return DECASSIGN;}
{mulassign} {printf("\nMULASSIGN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return MULASSIGN;}
{divassign} {printf("\nDIVASSIGN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return DIVASSIGN;}


{plus}      {printf("\nPLUS");   strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return PLUS;}
{minus}     {printf("\nMINUS");  strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));      return MINUS;}
{mult}      {printf("\nMULT");   strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return MULT;}
{divide}    {printf("\nDIVIDE"); strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return DIVIDE;}
{rem}       {printf("\nREM");    strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return REM;}
{bitand}    {printf("\nBITAND"); strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return BITAND;}
{bitor}     {printf("\nBITOR");  strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return BITOR;}
{neg}       {printf("\nNEG");    strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return NEG;}
{xor}       {printf("\nXOR");    strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return XOR;}
{and}       {printf("\nAND");    strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return AND;}
{or}        {printf("\nOR");     strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return OR;}


{lparen}    {printf("\nLPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));   return LPAREN;}
{rparen}    {printf("\nRPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));   return RPAREN;}
{lsparen}   {printf("\nLSPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LSPAREN;}
{rsparen}   {printf("\nRSPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RSPAREN;}
{lcparen}   {printf("\nLCPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LCPAREN;}
{rcparen}   {printf("\nRCPAREN");strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RCPAREN;}



{number}                        {printf("\nNUMBER: %s", yytext); strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return NUMBER;}
{float}                         {printf("\nFLOAT: %s", yytext); strcpy(yylval.nd_obj.name,(yytext)); tokens.push_back(strdup(yytext));     return FLOAT;}
{identifier}                    {
                                    printf("\nIDENTIFIER: %s", yytext); 
                                    tokens.push_back(strdup(yytext)); 
                                    strcpy(yylval.nd_obj.name,(yytext)); 
                                    if(tokens[tokens.size()-2]=="let"){
                                        ma[tokens[tokens.size()-1]]="name:"+tokens[tokens.size()-1]+";"+"scope: "+to_string(lines)+";";
                                        cout<<"\nIDENTIFIER: "<<ma[tokens[tokens.size()-1]]<<endl; 
                                    }else if(tokens[tokens.size()-2]=="function"){
                                        curr_function = strdup(yytext);
                                        cout<<"\nNAME OF FUNCTION: "<<curr_function<<endl; 
                                    }
                                    return IDENTIFIER;
                                }

{comma}                         {printf("\COMMA");  tokens.push_back(strdup(yytext)); return COMMA;}
{semicol}                       {printf("\nSEMICOL");tokens.push_back(strdup(yytext));   return SEMICOL;}
{space}                         {} 
\n                           {printf("\n"); countn++; lines++;}
\r                           {printf("\n"); }
\t                              {printf("\t"); }
 .                              {printf("\n!!!Illegal Token!!!");}
"@@@" 		                    {printf("\nFinished Parsing."); return 0;}

%%


int yywrap(){return 0;}
