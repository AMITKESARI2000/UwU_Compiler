%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  #include<ctype.h>
  #include<string>
  #include<iostream>
  #include<iomanip>
  #include<queue>
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
		char* join(char *, char*);
    
    void printtree(struct node*);
    void printInorder(struct node *,int);
    void printPreorder(struct node *,int);
    void printLevelorder(struct node *,int);
    struct node* mknode(struct node *left, struct node *right, char *token, string code);

    struct dataType {
        char *id_name;
        char *data_type;
        char *type;
        int line_no;
    } symbolTable[40];
    int count=0;
    int q;
	char datatype [10];
    char type[10];
    extern int countn;

    struct node { 
		struct node *left; 
		struct node *right; 
		char *token; 
		string code;
    };
    struct node *head;

	char* iden_name;
	string ircode;


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
%type  <nd_obj> program stment_seq STATEMENT ARRAY VARIABLES arithmetic PARAMS EXPR BOOLEANS CONDITION CONDITIONAL_STAMENT FUNCTIONCALL FUNCTIONDEF INCREMENT Loop END_DECL TYPE_DECL 

%%

program:  stment_seq {ircode = $1.nd->code; $$.nd=mknode($1.nd, NULL, "Program", ircode); head = $$.nd; cout << "\n\nGot my ircode@@@@@@ " << $$.nd->code << endl; };


stment_seq:
STATEMENT stment_seq { ircode = $1.nd->code + $2.nd->code; $$.nd=mknode($1.nd, $2.nd,"Statements", ircode );  }| 
STATEMENT {$$.nd = $1.nd;}
;

STATEMENT:
LET { insert_type(); } TYPE_DECL { ircode = " " + $3.nd->code; $$.nd = mknode($3.nd,NULL,"Let Statement", ircode); }|
CONST { insert_type(); } IDENTIFIER{ add('V'); } ASSIGN EXPR{
									int i=0;
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$3.name)==0)
											break;
									if(i<count)
									symbolTable[i].data_type=strdup(datatype);
									}
									SEMICOL {ircode = " " + $3.nd->code; $3.nd=mknode(NULL,NULL,$3.name, ircode); ircode = ircode + $6.nd->code; $$.nd=mknode($3.nd, $6.nd,"Const_declaration", ircode);}|
IDENTIFIER ASSIGN EXPR SEMICOL { ircode = string($1.name) + " = " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "=", ircode); }|
IDENTIFIER INCASSIGN VARIABLES SEMICOL { ircode = string($1.name) + " += " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "+=", ircode); }|
IDENTIFIER DECASSIGN VARIABLES SEMICOL { ircode = string($1.name) + " -= " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "-=", ircode); }|
IDENTIFIER INCONE SEMICOL { ircode = string($1.name) + " += " + "1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, "1"); $$.nd = mknode($1.nd, $2.nd, "INCREMENT", ircode); }|
IDENTIFIER DECONE SEMICOL { ircode = string($1.name) + " -= " + "1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, "1"); $$.nd = mknode($1.nd, $2.nd, "DECREMENT", ircode); }|
ARRAY ASSIGN EXPR SEMICOL |
ARRAY INCASSIGN VARIABLES SEMICOL |
ARRAY DECASSIGN VARIABLES SEMICOL |
ARRAY INCONE SEMICOL |
ARRAY DECONE SEMICOL |
PRINT LPAREN EXPR RPAREN SEMICOL { ircode = "print " + $3.nd->code + ";"; $3.nd = mknode(NULL,NULL,$3.name, "print expr"); $$.nd = mknode(NULL,$3.nd,"Print_expr", ircode); }|
PRINT LPAREN FUNCTIONCALL RPAREN SEMICOL { ircode = "print "+ $3.nd->code +";"; $3.nd = mknode(NULL,NULL,$3.name, "functioncall "); $$.nd = mknode(NULL,$3.nd,"Print_functionvalue", ircode); }|
INPUT LPAREN IDENTIFIER RPAREN SEMICOL { ircode = "syscall input \n"; $3.nd = mknode(NULL,NULL,$3.name, $3.name); $$.nd = mknode(NULL,$3.nd,"Input", ircode); }|
CONDITIONAL_STAMENT{ $$.nd=$1.nd; } |
Loop { $$.nd=$1.nd; }|
RETURN {add('K'); } EXPR SEMICOL{ ircode = " return "; $1.nd = mknode(NULL, NULL, "Return", ircode); ircode = ircode + $3.nd->code + " goto NLINE\n"; $$.nd = mknode($1.nd, $3.nd, "RETURN", ircode); }|
FUNCTIONCALL SEMICOL { $$.nd=$1.nd; }|
FUNCTIONDEF |
STOP SEMICOL{ ircode = "goto N2LINE\n"; $$.nd=mknode(NULL,NULL,"STOP", ircode); }|
CONTINUE SEMICOL{ ircode = "goto NLINE"; $$.nd=mknode(NULL,NULL,"CONTINUE", ircode); };

ARRAY:
ARRAY LSPAREN IDENTIFIER RSPAREN |
ARRAY LSPAREN NUMBER RSPAREN |
IDENTIFIER LSPAREN IDENTIFIER RSPAREN |
IDENTIFIER LSPAREN NUMBER RSPAREN;

TYPE_DECL:
IDENTIFIER { add('V'); iden_name = strdup($1.name);} END_DECL {ircode = iden_name + $3.nd->code; $$.nd = mknode($3.nd,NULL,"Type_decl", ircode); }|
ARRAY SEMICOL {add('A'); };

END_DECL:
ASSIGN EXPR {
	int i=0;
	for(i=0;i<count;i++){
		if(strcmp(symbolTable[i].id_name,iden_name)==0)
			break;
	}
	if(i<count)
		symbolTable[i].data_type=strdup(datatype);
	} SEMICOL {ircode = " = " + $2.nd->code + "\n"; $$.nd=mknode(mknode(NULL,NULL,iden_name, iden_name),$2.nd,"End_Initialization", ircode); }|
SEMICOL {$$.nd=mknode(mknode(NULL,NULL,iden_name, iden_name),NULL,"End_Declaration", "\n");};


VARIABLES: 
IDENTIFIER {ircode = " " + string($1.name); $$.nd = mknode(NULL, NULL, $1.name, ircode);
									int i=0;
									
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$1.name)==0)
											break;
									if(i<count)
										strcpy(datatype,symbolTable[i].data_type);
										
									}|
STRING { add('C'); ircode = " " + string(yytext); $$.nd = mknode(NULL, NULL, $1.name, ircode); strcpy(datatype,"STRING"); }| 
NUMBER { add('C'); ircode = " " + string($1.name); $$.nd = mknode(NULL, NULL, $1.name, ircode); strcpy(datatype,"INT");}| 
FLOAT  { add('C'); ircode = " " + string($1.name); $$.nd = mknode(NULL, NULL, $1.name, ircode); strcpy(datatype,"FLOAT");}| 
ARRAY; 

PARAMS:
PARAMS COMMA VARIABLES |
EXPR |
FUNCTIONCALL |
;

arithmetic:
PLUS  {$$.nd = mknode(NULL, NULL, "PLUS", "+");}|
MINUS {$$.nd = mknode(NULL, NULL, "MINUS", "-");}|
MULT  {$$.nd = mknode(NULL, NULL, "MULT", "*");}|
DIVIDE{$$.nd = mknode(NULL, NULL, "DIVIDE", "/");}|
REM	  {$$.nd = mknode(NULL, NULL, "REM", "%");}|
BITAND{$$.nd = mknode(NULL, NULL, "BITAND", "&");}|
BITOR {$$.nd = mknode(NULL, NULL, "BITOR", "|");}|
XOR   {$$.nd = mknode(NULL, NULL, "XOR", "^");};

EXPR:
LPAREN EXPR RPAREN { $$.nd = $2.nd; } |
EXPR arithmetic VARIABLES { ircode = "(" + $1.nd->code + $2.nd->code + ")" + $3.nd->code; $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
EXPR arithmetic FUNCTIONCALL { ircode = "(" + $1.nd->code + $2.nd->code + ")" + $3.nd->code; $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
VARIABLES { $$.nd = $1.nd;} |
IDENTIFIER INCONE { $$.nd = $1.nd; } |
IDENTIFIER DECONE { $$.nd = $1.nd; };

BOOLEANS:
EXPR EQ VARIABLES {ircode = $1.nd->code + " == " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, "==", ircode);}|
EXPR NE VARIABLES {ircode = $1.nd->code + " != " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, "!=", ircode);}|
EXPR LT VARIABLES {ircode = $1.nd->code + " < " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, "<", ircode);}|
EXPR LE VARIABLES {ircode = $1.nd->code + " <= " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, "<=", ircode);}|
EXPR GT VARIABLES {ircode = $1.nd->code + " > " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, ">", ircode);}|
EXPR GE VARIABLES {ircode = $1.nd->code + " >= " + $3.nd->code + "\n"; $$.nd = mknode($1.nd, $3.nd, ">=", ircode);}
;

CONDITION:
LPAREN CONDITION RPAREN {$$.nd = $2.nd;} |
CONDITION AND BOOLEANS {ircode = $1.nd->code + "&&" + $3.nd->code; $2.nd = mknode(NULL, NULL, "AND", "&&"); $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
CONDITION OR BOOLEANS {ircode = $1.nd->code + "||" + $3.nd->code; $2.nd = mknode(NULL, NULL, "OR", "||"); $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
CONDITION XOR BOOLEANS {ircode = $1.nd->code + "^" + $3.nd->code; $2.nd = mknode(NULL, NULL, "XOR", "^"); $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
BOOLEANS { $$.nd = $1.nd;}|
NEG BOOLEANS {ircode = "!" + $2.nd->code; $1.nd = mknode(NULL, NULL, "NEG", "!"); $$.nd = mknode(NULL, $2.nd, $1.name, ircode);}
;

CONDITIONAL_STAMENT:
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN { ircode = "if1 " + $3.nd->code + " goto NLINE\n";  add('K'); struct node *iff = mknode($3.nd, $6.nd, "IF", ircode); ircode = ircode + $6.nd->code; $$.nd = mknode(iff, NULL, "if-else", ircode); }|
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE LCPAREN stment_seq RCPAREN {  ircode = "if " + $3.nd->code + " goto N1LINE\n";  add('K'); struct node *iff = mknode($3.nd, $6.nd, "IF", ircode); ircode = ircode + $6.nd->code + "\n goto N3LINE\n " + $10.nd->code ; $$.nd = mknode(iff, $10.nd, "if-else", ircode); }|
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE CONDITIONAL_STAMENT{ ircode = "if " + $3.nd->code + " goto NLINE\n"; add('K'); struct node *iff = mknode($3.nd, $6.nd, "IF", ircode); ircode = ircode + "\n goto N2line\n " + $9.nd->code ; $$.nd = mknode(iff, $9.nd, "if-else-if", ircode);};


FUNCTIONCALL:
IDENTIFIER LPAREN PARAMS RPAREN {ircode =  "Label " + string($1.name)+": "; $$.nd=mknode(NULL,NULL,$1.name, ircode);}|
MAIN LPAREN PARAMS RPAREN{ircode = "Label main: "; $$.nd=mknode(NULL,NULL,$1.name, ircode);};

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN {ircode = $2.nd->code + $4.nd->code;  $$.nd=mknode($4.nd, NULL, "Function", ircode); };

INCREMENT:
IDENTIFIER ASSIGN EXPR {ircode = string($1.name) + " += " + $3.nd->code + "\n"; $1.nd=mknode(NULL,NULL,$1.name, $1.name);$$.nd=mknode($1.nd,$3.nd,"ITERATOR", ircode);}|
IDENTIFIER INCONE { $1.nd = mknode(NULL, NULL, $1.name, "byee"); $2.nd = mknode(NULL, NULL, $2.name, "byee"); $$.nd = mknode($1.nd, $2.nd, "ITERATOR", "byee"); }|
IDENTIFIER DECONE { $1.nd = mknode(NULL, NULL, $1.name, "byee"); $2.nd = mknode(NULL, NULL, $2.name, "byee"); $$.nd = mknode($1.nd, $2.nd, "ITERATOR", "byee"); };

Loop:
LOOP { add('K'); } LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN INCREMENT RPAREN { ircode = "if " + $4.nd->code +" goto NLINE\n"; struct node *temp = mknode($4.nd, $10.nd, "CONDITION", ircode); ircode = ircode + $7.nd->code + " goto N2LINE"; $$.nd = mknode(temp, $7.nd, $1.name, ircode); }; 



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
		// std::cout<<std::setw(space)<<symbolTable[i].id_name<<std::setw(space)<< symbolTable[i].data_type<<std::setw(space)<< symbolTable[i].type<<std::setw(space)<< symbolTable[i].line_no<<std::endl;
		printf("\t%s\t%s\t%s\t%d\t\n", symbolTable[i].id_name, symbolTable[i].data_type, symbolTable[i].type, symbolTable[i].line_no);
	}
	printtree(head);
	for(i=0;i<count;i++){
		free(symbolTable[i].id_name);
		free(symbolTable[i].type);
	}
	// TODO: delete tree nodes
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
		}else if(c=='A'){
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup("ARRAY");
			symbolTable[count].line_no=countn;
			symbolTable[count].type=strdup("Array");
			count++;
		}
    }
}

struct node* mknode(struct node *left, struct node *right, char *token, string code) {	
	// struct node *newnode = (struct node *)malloc(sizeof(struct node));
	struct node *newnode = new node;
	char *newstr = (char *)malloc(strlen(token)+1);
	// TODO: change token to string type
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	newnode->code = code;
	return(newnode);
}

void printtree(struct node* tree) {
	printf("\n\n Preorder traversal of the Parse Tree: \n\n");
	int space = 15;
	std::cout<<std::setw(space)<<"Level"<<std::setw(space)<< "Token" <<std::endl;
	
	printLevelorder(tree, 0);
	printf("\n\n");
}

void printPreorder(struct node *tree,int i) {
	int space = 15;
	std::cout<<std::setw(space)<< i <<std::setw(space)<< tree->token <<std::endl;
	
	if (tree->left) {
		printPreorder(tree->left,i+1);
	}
	
	if (tree->right) {
		printPreorder(tree->right,i+1);
	}
}

void printLevelorder(struct node *tree, int i){
	queue<std::pair<struct node *,int>> q;
	q.push({tree,0});

	while(!q.empty()){
		int space = 15;
		std::cout<<std::setw(space)<< q.front().second <<std::setw(space)<< q.front().first->token <<std::endl;
		if(q.front().first->left){
			q.push({q.front().first->left, q.front().second + 1});
		}
		if(q.front().first->right){
			q.push({q.front().first->right, q.front().second + 1});
		}
		q.pop();
	}

}

void printInorder(struct node *tree,int i) {
	if (tree->left) {
		printInorder(tree->left,i+1);
	}
	int space = 15;
	std::cout<<std::setw(space)<< i <<std::setw(space)<< tree->token <<std::endl;
	
	if (tree->right) {
		printInorder(tree->right,i+1);
	}
}

void insert_type() {
	strcpy(type, yytext);
}

int yyerror(char *s){
  std::cout<< "\n\nError: "<< s <<" in function "<< curr_function <<" in between lines "<< lines-1 <<" - " << lines+1 << std::endl;

}
