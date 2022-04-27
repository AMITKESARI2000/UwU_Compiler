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
{let}       {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LET;}
{const}     {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return CONST;}
{if}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return IF;}
{else}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return ELSE;}
{loop}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LOOP;}
{stop}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return STOP;}
{continue}  {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return CONTINUE;}
{function}  {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return FUNCTION;}
{return}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RETURN;}
{print}     {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return PRINT;}
{main}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  
                                        curr_function = strdup(yytext); 
                                         return MAIN;}
{input}     {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return INPUT;}

{comment_start}([^*]|\*+[^*$])*{comment_end}                {string s = strdup(yytext); for(int i=0;i<s.size();i++){if(s[i]=='\n')lines++;} }
\"(\\.|[^"\\])*\"     {tokens.push_back(strdup(yytext));  return STRING;}
\'(\\.|[^'\\])*\'     {tokens.push_back(strdup(yytext));  return STRING;}

{eq}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return EQ;}
{lt}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LT;}
{ne}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return NE;}
{le}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LE;}
{gt}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return GT;}
{ge}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return GE;}


{assign}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return ASSIGN;}
{incone}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return INCONE;}
{decone}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return DECONE;}
{incassign} {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return INCASSIGN;}
{decassign} {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return DECASSIGN;}
{mulassign} {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return MULASSIGN;}
{divassign} {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return DIVASSIGN;}


{plus}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return PLUS;}
{minus}     {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));      return MINUS;}
{mult}      {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return MULT;}
{divide}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return DIVIDE;}
{rem}       {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));       return REM;}
{bitand}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return BITAND;}
{bitor}     {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return BITOR;}
{neg}       {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return NEG;}
{xor}       {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return XOR;}
{and}       {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return AND;}
{or}        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));    return OR;}


{lparen}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));   return LPAREN;}
{rparen}    {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));   return RPAREN;}
{lsparen}   {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LSPAREN;}
{rsparen}   {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RSPAREN;}
{lcparen}   {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return LCPAREN;}
{rcparen}   {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));  return RCPAREN;}



{number}                        {strcpy(yylval.nd_obj.name,(yytext));tokens.push_back(strdup(yytext));     return NUMBER;}
{float}                         {strcpy(yylval.nd_obj.name,(yytext)); tokens.push_back(strdup(yytext));     return FLOAT;}
{identifier}                    {
                                    tokens.push_back(strdup(yytext)); 
                                    strcpy(yylval.nd_obj.name,(yytext)); 
                                    if(tokens[tokens.size()-2]=="let"){
                                        ma[tokens[tokens.size()-1]]="name:"+tokens[tokens.size()-1]+";"+"scope: "+to_string(lines)+";";
                                    }else if(tokens[tokens.size()-2]=="function"){
                                        curr_function = strdup(yytext);
                                    }
                                    return IDENTIFIER;
                                }

{comma}                         {tokens.push_back(strdup(yytext)); return COMMA;}
{semicol}                       {tokens.push_back(strdup(yytext));   return SEMICOL;}
{space}                         {} 
\n                           {countn++; lines++;}
\r                           
\t                              
 .                              {printf("\n!!!Illegal Token!!!");}
"@@@" 		                    {return 0;}

%%


int yywrap(){return 0;}
