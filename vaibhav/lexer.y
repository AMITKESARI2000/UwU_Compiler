%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<ctype.h>
  #include"lex.yy.c"

//  extern FILE * yyin;

  int yylex();
  int yyerror(char *);
  
  int yywrap();
    void add(char);
    void insert_type();
    int search(char *);
    void insert_type();
    void printtree(struct node*);
    void printInorder(struct node *);
    struct node* mknode(struct node *left, struct node *right, char *token);

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
    } symbolTable[40];
    int count=0;
    int q;
    char type[10];
    extern int countn;
    struct node *head;
    struct node { 
	struct node *left; 
	struct node *right; 
	char *token; 
    };

%}

%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 
} 

%token LET CONST IF ELSE LOOP STOP CONTINUE FUNCTION RETURN PRINT MAIN INPUT STRING EQ 
%token LT NE LE GT GE ASSIGN INCONE DECONE INCASSIGN DECASSIGN MULASSIGN DIVASSIGN PLUS 
%token MINUS MULT DIVIDE REM BITAND BITOR NEG XOR AND OR LPAREN RPAREN LSPAREN RSPAREN 
%token LCPAREN RCPAREN NUMBER FLOAT IDENTIFIER SEMICOL COMMA
%%

stment_seq: STATEMENT | stment_seq STATEMENT ;

program:
main LPAREN RPAREN LCPAREN stment_seq RCPAREN{ $1.nd = mknode($5.nd, NULL, "main"); $$.nd = mknode(NULL, $1.nd, "program"); head = $$.nd; };

main:
FUNCTION MAIN ;

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
IDENTIFIER LPAREN PARAMS RPAREN ;

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN;


INCREMENT:
IDENTIFIER ASSIGN EXPR |
IDENTIFIER INCONE SEMICOL |
IDENTIFIER DECONE SEMICOL ;

Loop:
LOOP { add('K'); } LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN INCREMENT RPAREN { struct node *temp = mknode($4.nd, $10.nd, "CONDITION"); $$.nd = mknode(temp, $7.nd, $1.name); }; 


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
	printInorder(head);
}

int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbolTable[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void add(char c) {
    q=search(yytext);
	if(q==0) {
		if(c=='H') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup(type);
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Header");
			count++;
		}
		else if(c=='K') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup("N/A");
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Keyword\t");
			count++;
		}
		else if(c=='V') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup(type);
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Variable");
			count++;
		}
		else if(c=='C') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup("CONST");
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Constant");
			count++;
		}
    }
}

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return(newnode);
}

void printtree(struct node* tree) {
	printf("\n\n Inorder traversal of the Parse Tree: \n\n");
	printInorder(tree);
	printf("\n\n");
}

void printInorder(struct node *tree) {
	int i;
	if (tree->left) {
		printInorder(tree->left);
	}
	printf("%s, ", tree->token);
	if (tree->right) {
		printInorder(tree->right);
	}
}

void insert_type() {
	strcpy(type, yytext);
}

int yyerror(char *s){
  printf("\n\nError: %s\n", s);
}