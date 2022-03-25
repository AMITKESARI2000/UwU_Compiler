%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<ctype.h>
  #include<string>
  #include<iostream>
  #include<iomanip>
  using namespace std;

  extern FILE * yyin;
  extern char *yytext;
  extern int lines;
  extern string curr_function;

  int yylex();
  int yyerror(char *);
  
  int yywrap();
    void add(char);
    void insert_type();
	void insert();
    int search(char *);
    
    void printtree(struct node*);
    void printInorder(struct node *,int);
    struct node* mknode(struct node *left, struct node *right, char *token);

    struct dataType {
        char *id_name;
        char *data_type;
        char *type;
        int line_no;
    } symbolTable[40];
    int count=0;
    int q;
	char temp [10];
    char type[10];
    extern int countn;

    struct node { 
		struct node *left; 
		struct node *right; 
		char *token; 
    };
    struct node *head;



%}

%union { 
	struct var_name { 
		char name[100]; 
		struct node *nd;
	} nd_obj; 
}



%token <nd_obj> LET CONST IF ELSE LOOP STOP CONTINUE FUNCTION RETURN PRINT MAIN INPUT STRING EQ 
%token <nd_obj> LT NE LE GT GE ASSIGN INCONE DECONE INCASSIGN DECASSIGN MULASSIGN DIVASSIGN 
%left  <nd_obj> MULT DIVIDE PLUS MINUS 
%right <nd_obj> NEG
%token <nd_obj> REM BITAND BITOR XOR AND OR LPAREN RPAREN LSPAREN RSPAREN 
%token <nd_obj> LCPAREN RCPAREN NUMBER FLOAT IDENTIFIER SEMICOL COMMA
%type <nd_obj> program stment_seq ARRAY VARIABLES arithmetic return_rule PARAMS EXPR BOOLEANS CONDITION CONDITIONAL_STAMENT FUNCTIONCALL FUNCTIONDEF INCREMENT Loop 

%%

program:  stment_seq {$$.nd=mknode($1.nd,NULL,"Program");head = $$.nd;};



stment_seq:
stment_seq stment_seq{$$.nd=mknode($1.nd,$2.nd,"statements");}|
LET{ insert_type(); } IDENTIFIER{ add('V'); } ASSIGN EXPR{int i=0;
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$3.name)==0)
											break;
									if(i<count)
										symbolTable[i].data_type=strdup(temp);
									}
									 SEMICOL {$$.nd=mknode(mknode(NULL,NULL,$3.name),$6.nd,"declaration");}|
CONST{ insert_type(); } IDENTIFIER{ add('V'); } ASSIGN EXPR{int i=0;
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$3.name)==0)
											break;
									if(i<count)
									symbolTable[i].data_type=strdup(temp);
									}
									 SEMICOL {$3.nd=mknode(NULL,NULL,$3.name);$$.nd=mknode($3.nd,$6.nd,"const_declaration");}|
LET{ insert_type(); } IDENTIFIER{ add('V'); } SEMICOL {$3.nd=mknode(NULL,NULL,$3.name);$$.nd=mknode($3.nd,NULL,"initialization");}|
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
RETURN { add('K'); } EXPR SEMICOL{ $1.nd = mknode(NULL, NULL, "return"); $$.nd = mknode($1.nd, $3.nd, "RETURN"); }|
FUNCTIONCALL SEMICOL { $$.nd=$1.nd; }|
FUNCTIONDEF |
STOP SEMICOL{ $$.nd=mknode(NULL,NULL,"STOP"); }|
CONTINUE SEMICOL{ $$.nd=mknode(NULL,NULL,"CONTINUE"); };

ARRAY:
ARRAY LSPAREN IDENTIFIER RSPAREN |
ARRAY LSPAREN NUMBER RSPAREN |
IDENTIFIER LSPAREN IDENTIFIER RSPAREN |
IDENTIFIER LSPAREN NUMBER RSPAREN;


VARIABLES: 
IDENTIFIER {$$.nd = mknode(NULL, NULL, $1.name); int i=0;
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$1.name)==0)
											break;
									if(i<count)
										strcpy(temp,symbolTable[i].data_type);
									}|
NUMBER { add('C'); $$.nd = mknode(NULL, NULL, $1.name); strcpy(temp,"INT");}| 
STRING { add('C'); $$.nd = mknode(NULL, NULL, $1.name); strcpy(temp,"STRING");}| 
FLOAT { add('C'); $$.nd = mknode(NULL, NULL, $1.name); strcpy(temp,"FLOAT");}| 
ARRAY; 

PARAMS:
PARAMS COMMA VARIABLES |
EXPR |
FUNCTIONCALL |
;

arithmetic:
PLUS |
MINUS|
MULT |
DIVIDE|
REM	 |
BITAND|
BITOR|
XOR;

EXPR:
LPAREN EXPR RPAREN { $$.nd = $2.nd; } |
EXPR arithmetic VARIABLES { $$.nd = mknode($1.nd, $3.nd, $2.name);}|
EXPR arithmetic FUNCTIONCALL { $$.nd = mknode($1.nd, $3.nd, $2.name); } |
VARIABLES { $$.nd = $1.nd; } |
FUNCTIONCALL { $$.nd = $1.nd; } |
IDENTIFIER INCONE { $$.nd = $1.nd; } |
IDENTIFIER DECONE { $$.nd = $1.nd; };

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
IDENTIFIER LPAREN PARAMS RPAREN {$$.nd=mknode(NULL,NULL,$1.name);}|
MAIN LPAREN PARAMS RPAREN{$$.nd=mknode(NULL,NULL,$1.name);};

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN {$$.nd=mknode($4.nd,NULL,"function");};

INCREMENT:
IDENTIFIER ASSIGN EXPR {$1.nd=mknode(NULL,NULL,$1.name);$$.nd=mknode($1.nd,$3.nd,"ITERATOR");}|
IDENTIFIER INCONE { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR"); }|
IDENTIFIER DECONE { $1.nd = mknode(NULL, NULL, $1.name); $2.nd = mknode(NULL, NULL, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR"); };

Loop:
LOOP { add('K'); } LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN INCREMENT RPAREN { struct node *temp = mknode($4.nd, $10.nd, "CONDITION"); $$.nd = mknode(temp, $7.nd, $1.name); }; 




%%

int main(int argc, char *argv[])
{
   if (argc != 2) {
       printf("\nUsage: <exefile> <inputfile>\n\n");
       exit(0);
   }
   yyin = fopen(argv[1], "r");
  yyparse();
  printf("\n");
  int i=0;
  int space =15;
  std::cout<<std::setw(space*3)<<"SYMBOL TABLE"<<std::endl;
  std::cout<<std::endl;
  std::cout<<std::setw(space)<<"IDENTIFIER"<<std::setw(space)<<"TYPE"<<std::setw(space)<<"let/const"<<std::setw(space)<<"line No"<<std::endl;
	for(i=0; i<count; i++) {
		std::cout<<std::setw(space)<<symbolTable[i].id_name<<std::setw(space)<< symbolTable[i].data_type<<std::setw(space)<< symbolTable[i].type<<std::setw(space)<< symbolTable[i].line_no<<std::endl;
		// printf("%s\t%s\t%s\t%d\t\n", symbolTable[i].id_name, symbolTable[i].data_type, symbolTable[i].type, symbolTable[i].line_no);
	}
	for(i=0;i<count;i++){
		free(symbolTable[i].id_name);
		free(symbolTable[i].type);
	}
	printtree(head);
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
		if(c=='K') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup("N/A");
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Keyword\t");
			count++;
		}
		else if(c=='V') {
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup(type);
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
	int space = 15;
	std::cout<<std::setw(space)<<"Level"<<std::setw(space)<< "Token" <<std::endl;
	
	printInorder(tree, 0);
	printf("\n\n");
}

void printInorder(struct node *tree,int i) {
	if (tree->left) {
		printInorder(tree->left,i+1);
	}
	int space = 15;
	std::cout<<std::setw(space)<< i <<std::setw(space)<< tree->token <<std::endl;
	
	// printf("%d  %s, \n",i, tree->token);
	if (tree->right) {
		printInorder(tree->right,i+1);
	}
}

void insert_type() {
	strcpy(type, yytext);
}

int yyerror(char *s){
  std::cout<< "\n\nError: "<< s <<" in function "<< curr_function <<" in between lines "<< lines-1 <<" - " << lines+1 << std::endl;

//   printf("\n\nError: %s\n", s);
}