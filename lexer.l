%{

    int a = 0;

%}
let "let"
const "const"
if "if"
else "else"
loop "loop"
stop "stop"
continue "continue"
function "function"
return "return"
print "print"
main "main"

eq "=="
ne "!="
lt "<"
le "<="
gt ">"
ge ">="

assign "="
incone "++"
decone "--"
incassign "+="
decassign "-="
mulassign "*="
divassign "/="

plus "+"
minus "-"
mult "*"
divide "/"
rem "%"
bitand "&"
bitor "|"
neg "!"
xor "^"
and "&&"
or "||"

lparen "("
rparen ")"
lsparen "["
rsparen "]"
lcparen "{"
rcparen "}"

comment "$$"
semicol ";"
space " "

digit [0-9]
number digit+
letter [A-Za-z]
letter_ [A-Za-z_]
identifier {letter_}+({digit}|{letter_})*

expr ({identifier}{relop}{identifier}|{identifier})

%%
{let}|{const}|{if}|{else}|{loop}|{stop}|{continue}|{function}|{return}|{print}|{main}     {printf("\nKEYWORD: %s", yytext);}

{comment}({identifier}|{digit}+|{space})*{comment}   {printf("\nCOMMENT: %s", yytext);}

{eq}        {printf("\nEQ");}
{ne}        {printf("\nNE");}
{lt}        {printf("\nLT");}
{le}        {printf("\nLE");}
{gt}        {printf("\nGT");}
{ge}        {printf("\nGE");}


{assign}    {printf("\nASSIGN");}
{incone}    {printf("\nINCONE");}
{decone}    {printf("\nDECONE");}
{incassign} {printf("\nINCASSIGN");}
{decassign} {printf("\nDECASSIGN");}
{mulassign} {printf("\nMULASSIGN");}
{divassign} {printf("\nDIVASSIGN");}


{plus}      {printf("\nPLUS");}
{minus}     {printf("\nMINUS");}
{mult}      {printf("\nMULT");}
{divide}    {printf("\nDIVIDE");}
{rem}       {printf("\nREM");}
{bitand}    {printf("\nBITAND");}
{bitor}     {printf("\nBITOR");}
{neg}       {printf("\nNEG");}
{xor}       {printf("\nXOR");}
{and}       {printf("\nAND");}
{or}        {printf("\nOR");}


{lparen}    {printf("\nLPAREN");}
{rparen}    {printf("\nRPAREN");}
{lsparen}   {printf("\nLSPAREN");}
{rsparen}   {printf("\nRSPAREN");}
{lcparen}   {printf("\nLCPAREN");}
{rcparen}   {printf("\nRCPAREN");}

{semicol}   {printf("\nSEMICOL");}


{digit}+                        {printf("\nNUMBER: %s", yytext); }
{identifier}                    {printf("\nIDENTIFIER: %s", yytext); }
\"({identifier}|{digit}+)\"     {printf("\nSTRING: %s", yytext);}

{space}                         {printf("");} 
 .                              {printf("\n!!!Illegal Token!!!");}

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
