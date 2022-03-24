%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<ctype.h>

  extern FILE * yyin;
  extern const char* yytext;

  int yylex();
  int yyerror(char *);
  
  int yywrap();
    void add(char);
    void insert_type();
    int search(const char *);
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

%token <nd_obj> LET CONST IF ELSE LOOP STOP CONTINUE FUNCTION RETURN PRINT MAIN INPUT STRING EQ 
%token <nd_obj> LT NE LE GT GE ASSIGN INCONE DECONE INCASSIGN DECASSIGN MULASSIGN DIVASSIGN PLUS 
%token <nd_obj> MINUS MULT DIVIDE REM BITAND BITOR NEG XOR AND OR LPAREN RPAREN LSPAREN RSPAREN 
%token <nd_obj> LCPAREN RCPAREN NUMBER FLOAT IDENTIFIER SEMICOL COMMA
%type <nd_obj> stment_seq program main ARRAY VARIABLES arithmetic return PARAMS EXPR BOOLEANS CONDITION CONDITIONAL_STAMENT FUNCTIONCALL FUNCTIONDEF INCREMENT Loop STATEMENT
%%

stment_seq: STATEMENT {$$.nd=mknode(NULL,NULL,$1.name);head = $$.nd;} | 
stment_seq STATEMENT { $$.nd = mknode($1.nd, $2.nd, "statements"); head = $$.nd;} ;

ARRAY:
ARRAY LSPAREN IDENTIFIER RSPAREN |
ARRAY LSPAREN NUMBER RSPAREN |
IDENTIFIER LSPAREN IDENTIFIER RSPAREN |
IDENTIFIER LSPAREN NUMBER RSPAREN;


VARIABLES: 
IDENTIFIER { $$.nd = mknode(NULL, NULL, $1.name); }|
NUMBER { add('C'); $$.nd = mknode(NULL, NULL, $1.name); }| 
STRING { add('C'); $$.nd = mknode(NULL, NULL, $1.name); }| 
FLOAT { add('C'); $$.nd = mknode(NULL, NULL, $1.name); }| 
ARRAY; 

PARAMS:
PARAMS COMMA VARIABLES |
EXPR |
FUNCTIONCALL |
;


EXPR:
LPAREN EXPR RPAREN { $$.nd = $2.nd; } |
VARIABLES { $$.nd = $1.nd; } |
EXPR arithmetic FUNCTIONCALL { $$.nd = mknode($1.nd, $3.nd, $2.name); } |
EXPR arithmetic VARIABLES { $$.nd = mknode($1.nd, $3.nd, $2.name); } |
FUNCTIONCALL { $$.nd = $1.nd; } |
IDENTIFIER INCONE { $$.nd = $1.nd; } |
IDENTIFIER DECONE { $$.nd = $1.nd; };

arithmetic:
PLUS { $$.nd = mknode(NULL, NULL, "plus"); }|
MINUS { $$.nd = mknode(NULL, NULL, "minus"); }|
MULT { $$.nd = mknode(NULL, NULL, "multi"); }|
DIVIDE { $$.nd = mknode(NULL, NULL, "divide"); }|
REM	 { $$.nd = mknode(NULL, NULL, "rem"); }|
BITAND { $$.nd = mknode(NULL, NULL, "bitand"); }|
BITOR{ $$.nd = mknode(NULL, NULL, "bitor"); }|
XOR{ $$.nd = mknode(NULL, NULL, "xor"); };


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
IF  { add('K'); }  LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN { struct node *iff = mknode($4.nd, $7.nd, $1.name); 	$$.nd = mknode(iff, NULL, "if-else"); }|
IF  { add('K'); }  LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE LCPAREN stment_seq RCPAREN { struct node *iff = mknode($4.nd, $7.nd, $1.name); 	$$.nd = mknode(iff, $11.nd, "if-else"); }|
IF  { add('K'); }  LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE CONDITIONAL_STAMENT{ struct node *iff = mknode($4.nd, $7.nd, $1.name); 	$$.nd = mknode(iff, $10.nd, "if-else"); };

FUNCTIONCALL:
IDENTIFIER LPAREN PARAMS RPAREN |
MAIN LPAREN PARAMS RPAREN;

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq return RCPAREN {$$.nd=mknode($4.nd,NULL,"function");};

return: RETURN { add('K'); } EXPR ';' { $1.nd = mknode(NULL, NULL, "return"); $$.nd = mknode($1.nd, $3.nd, "RETURN"); }
| { $$.nd = NULL; };

INCREMENT:
IDENTIFIER ASSIGN EXPR {$1.nd=mknode(NULL,NULL,$1.name);$$.nd=mknode($1.nd,$3.nd,"ITERATOR");}|
IDENTIFIER INCONE { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR"); }|
IDENTIFIER DECONE { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR"); };

Loop:
LOOP { add('K'); } LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN INCREMENT RPAREN { struct node *temp = mknode($4.nd, $10.nd, "CONDITION"); $$.nd = mknode(temp, $7.nd, $1.name); }; 


STATEMENT:
LET IDENTIFIER{ add('V'); } ASSIGN EXPR SEMICOL {$2.nd=mknode(NULL,NULL,$2.name);$$.nd=mknode($2.nd,$5.nd,"declaration");}|
CONST IDENTIFIER{ add('V'); } ASSIGN EXPR SEMICOL {$2.nd=mknode(NULL,NULL,$2.name);$$.nd=mknode($2.nd,$5.nd,"const_declaration");}|
LET IDENTIFIER SEMICOL {$2.nd=mknode(NULL,NULL,$2.name);$$.nd=mknode($2.nd,NULL,"initialization");}|
/*LET ARRAY SEMICOL |*/
IDENTIFIER ASSIGN EXPR SEMICOL { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, "="); }|
IDENTIFIER INCASSIGN VARIABLES SEMICOL { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, "+="); }|
IDENTIFIER DECASSIGN VARIABLES SEMICOL { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, "-="); }|
IDENTIFIER INCONE SEMICOL { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "INCREMENT"); }|
IDENTIFIER DECONE SEMICOL { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "DECREMENT"); }|
/*ARRAY ASSIGN EXPR SEMICOL |
ARRAY INCASSIGN VARIABLES SEMICOL |
ARRAY DECASSIGN VARIABLES SEMICOL |
ARRAY INCONE SEMICOL |
ARRAY DECONE SEMICOL |*/
PRINT LPAREN EXPR RPAREN SEMICOL { $3.nd = mknode(NULL,NULL,$3.name); $$.nd = mknode(NULL,$3.nd,"print_expr"); }|
PRINT LPAREN FUNCTIONCALL RPAREN SEMICOL { $3.nd = mknode(NULL,NULL,$3.name); $$.nd = mknode(NULL,$3.nd,"print_functionvalue"); }|
INPUT LPAREN IDENTIFIER RPAREN SEMICOL { $3.nd = mknode(NULL,NULL,$3.name); $$.nd = mknode(NULL,$3.nd,"input"); }|
CONDITIONAL_STAMENT{ $$.nd=$1.nd; } |
Loop { $$.nd=$1.nd; }|
FUNCTIONCALL SEMICOL { $$.nd=$1.nd; }|
FUNCTIONDEF |
STOP SEMICOL{ $$.nd=mknode(NULL,NULL,"STOP"); }|
CONTINUE SEMICOL{ $$.nd=mknode(NULL,NULL,"CONTINUE"); };

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

int search(const char *type) {
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