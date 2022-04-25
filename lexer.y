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
		void add_arr(char,string);
		void insert_type();
		void insert();
		int search(char *);
		char* join(char *, char*);
		vector<int> get_dim(string);
    
    void printtree(struct node*);
    void printInorder(struct node *,int);
    void printPreorder(struct node *,int);
    void printLevelorder(struct node *,int);
    struct node* mknode(struct node *left, struct node *right, char *token, string code);
	struct node* mknode(struct node *left, struct node *right, char *token, string code,int Label);
		string findArrIndex(string);
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
		int trueLabel = -1;
		int falseLabel= -1;
    };
    struct node *head;

	char* iden_name;
	string ircode;
	int irLabelCount = 0;
	int irtempCount = 0;
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

program:  stment_seq {ircode = $1.nd->code; $$.nd=mknode($1.nd, NULL, "Program", ircode); head = $$.nd; cout << "\n\nGot my ircode@@@@@@ \n" << $$.nd->code << endl; };


stment_seq:
STATEMENT stment_seq { ircode = $1.nd->code + $2.nd->code; $$.nd=mknode($1.nd, $2.nd,"Statements", ircode ); irtempCount = 0; }| 
STATEMENT {$$.nd = $1.nd;irtempCount = 0;}|
error SEMICOL {cout<<"Error on Line:: "<<lines<<endl;} stment_seq
;

STATEMENT:
LET { insert_type(); } TYPE_DECL { ircode = " _i " + $3.nd->code; $$.nd = mknode($3.nd,NULL,"Let Statement", ircode); }|
CONST { insert_type(); } IDENTIFIER{ add('V'); } ASSIGN EXPR{
									int i=0;
									for(i=0;i<count;i++)
										if(strcmp(symbolTable[i].id_name,$3.name)==0)
											break;
									if(i<count)
									symbolTable[i].data_type=strdup(datatype);
									}
									SEMICOL {ircode = " _c " + $3.nd->code; $3.nd=mknode(NULL,NULL,$3.name, ircode); ircode = ircode + $6.nd->code; $$.nd=mknode($3.nd, $6.nd,"Const_declaration", ircode);}|
IDENTIFIER ASSIGN EXPR SEMICOL { ircode = string($1.name) + " = " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "=", ircode); }|
IDENTIFIER INCASSIGN VARIABLES SEMICOL { ircode = string($1.name) + " += " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "+=", ircode); }|
IDENTIFIER DECASSIGN VARIABLES SEMICOL { ircode = string($1.name) + " -= " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "-=", ircode); }|
IDENTIFIER INCONE SEMICOL { ircode = string($1.name) + " = " + string($1.name) + " + 1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, "1"); $$.nd = mknode($1.nd, $2.nd, "INCREMENT", ircode); }|
IDENTIFIER DECONE SEMICOL { ircode = string($1.name) + " = " + string($1.name) + " - 1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, "1"); $$.nd = mknode($1.nd, $2.nd, "DECREMENT", ircode); }|
ARRAY ASSIGN EXPR SEMICOL {cout << "hi arrayy " << findArrIndex($1.nd->code) <<endl; ircode =  + " = " + $3.nd->code + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $$.nd = mknode($1.nd, $3.nd, "=", ircode); } |
ARRAY INCASSIGN VARIABLES SEMICOL |
ARRAY DECASSIGN VARIABLES SEMICOL |
ARRAY INCONE SEMICOL |
ARRAY DECONE SEMICOL |
PRINT LPAREN EXPR RPAREN SEMICOL { ircode = "print " + $3.nd->code + "\n"; $3.nd = mknode(NULL,NULL,$3.name, "print expr"); $$.nd = mknode(NULL,$3.nd,"Print_expr", ircode); }|
PRINT LPAREN FUNCTIONCALL RPAREN SEMICOL { ircode = "print "+ $3.nd->code +"\n"; $3.nd = mknode(NULL,NULL,$3.name, "functioncall "); $$.nd = mknode(NULL,$3.nd,"Print_functionvalue", ircode); }|
INPUT LPAREN IDENTIFIER RPAREN SEMICOL { ircode = "syscall input \n"; $3.nd = mknode(NULL,NULL,$3.name, $3.name); $$.nd = mknode(NULL,$3.nd,"Input", ircode); }|
CONDITIONAL_STAMENT{ $$.nd=$1.nd; } |
Loop { $$.nd=$1.nd; }|
RETURN {add('K'); } EXPR SEMICOL{ ircode = " return "; $1.nd = mknode(NULL, NULL, "Return", ircode); ircode = ircode + $3.nd->code + " goto NLINE\n"; $$.nd = mknode($1.nd, $3.nd, "RETURN", ircode); }|
FUNCTIONCALL SEMICOL { $$.nd=$1.nd; ircode = "GOTO " + $1.nd->code.substr(0, $1.nd->code.size()-2);  $1.nd->code = ircode; }|
FUNCTIONDEF |
STOP SEMICOL{ ircode = "goto N2LINE\n"; $$.nd=mknode(NULL,NULL,"STOP", ircode); }|
CONTINUE SEMICOL{ ircode = "goto NLINE"; $$.nd=mknode(NULL,NULL,"CONTINUE", ircode); };

ARRAY:
ARRAY LSPAREN NUMBER RSPAREN {
						ircode = $1.nd->code + "x" + $3.name;
						cout<<"array nigga:"<<ircode<<endl;
						$$.nd = mknode(NULL,NULL,"Array", ircode);
}|
ARRAY LSPAREN IDENTIFIER RSPAREN {
						ircode = $1.nd->code + "x" + $3.name;
						cout<<"array nigga:"<<ircode<<endl;
						$$.nd = mknode(NULL,NULL,"Array", ircode);
}|
IDENTIFIER LSPAREN NUMBER RSPAREN {
						ircode = string($1.name) + " : " + string($3.name);
						cout<<"array nigga:"<<ircode<<endl;
						$$.nd = mknode(NULL,NULL,"Array", ircode);
}|
IDENTIFIER LSPAREN IDENTIFIER RSPAREN {
						ircode = string($1.name) + " : " + string($3.name);
						$$.nd = mknode(NULL,NULL,"Array", ircode);
};

TYPE_DECL:
IDENTIFIER { add('V'); iden_name = strdup($1.name);} END_DECL {ircode = iden_name + $3.nd->code; $$.nd = mknode($3.nd,NULL,"Type_decl", ircode); }|
ARRAY SEMICOL {add_arr('A',$1.nd->code); ircode = "Assign " +  $1.nd->code +"\n"; $$.nd = mknode($1.nd,NULL,"Type_decl", ircode); };

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
EXPR arithmetic VARIABLES { 
							ircode =  $1.nd->code + $2.nd->code  + $3.nd->code;
							 $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);
							 
							 }|
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
CONDITION AND BOOLEANS {
						int Label = irLabelCount++;
						ircode = $1.nd->code +"GOTO L"+to_string(Label)+ "\n IF_FALSE" + $3.nd->code; 
						$2.nd = mknode(NULL, NULL, "AND", "&&"); 
						$$.nd = mknode($1.nd, $3.nd, $2.name, ircode,Label);
						}|
CONDITION OR BOOLEANS {
						int Label = irLabelCount++;
						ircode = $1.nd->code +"GOTO L"+to_string(Label)+"\n L"+to_string(Label)+ ": IF_FALSE" + $3.nd->code;
					 $2.nd = mknode(NULL, NULL, "OR", "||");
					  $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
CONDITION XOR BOOLEANS {ircode = $1.nd->code + "^" + $3.nd->code; $2.nd = mknode(NULL, NULL, "XOR", "^"); $$.nd = mknode($1.nd, $3.nd, $2.name, ircode);}|
BOOLEANS { $$.nd = $1.nd;}|
NEG BOOLEANS {ircode = "!" + $2.nd->code; $1.nd = mknode(NULL, NULL, "NEG", "!"); $$.nd = mknode(NULL, $2.nd, $1.name, ircode);}
;

CONDITIONAL_STAMENT:
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN { int iflastindex ; 
					ircode = "IF_FALSE " + $3.nd->code + "GOTO L"; 
					if($3.nd->trueLabel==-1)
					iflastindex=irLabelCount++;
					else
					iflastindex=$3.nd->trueLabel;
					ircode+= to_string(irLabelCount++) + "\n";  
					add('K'); struct node *iff = mknode($3.nd, $6.nd, "IF", ircode); 
					ircode = ircode + $6.nd->code + "L" + to_string(iflastindex) +":\n"; 
					$$.nd = mknode(iff, NULL, "if-else", ircode,iflastindex);
					 }|
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE LCPAREN stment_seq RCPAREN { int iflastindex ,elseend;
										  ircode = "IF_FALSE " + $3.nd->code + " GOTO "+"L";
										  if($3.nd->trueLabel==-1)
											iflastindex=irLabelCount++;
										  else
											iflastindex=$3.nd->trueLabel;
										  elseend=irLabelCount++;
										  ircode += to_string(iflastindex)+" \n";  add('K'); 
										  struct node *iff = mknode($3.nd, $6.nd, "IF", ircode); 
										  ircode = ircode + $6.nd->code + "\n GOTO L"+to_string(elseend)+"\n L"+to_string(iflastindex)+": " + $10.nd->code+"\n L"+to_string(elseend) +":";
										   $$.nd = mknode(iff, $10.nd, "if-else", ircode,elseend);
										    }|
IF LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN ELSE CONDITIONAL_STAMENT{ int iflastindex ,elseend;
										if($3.nd->trueLabel==-1)
											iflastindex=irLabelCount++;
										else
											iflastindex=$3.nd->trueLabel;
										if($9.nd->trueLabel!=-1)
										elseend = $9.nd->trueLabel;
										else
										elseend = irLabelCount++;
										ircode = "IF_FALSE " + $3.nd->code + " GOTO "+"L"+to_string(iflastindex)+" \n" + $6.nd->code + "\n" + "goto L" + to_string(elseend)+"\n";
										add('K'); struct node *iff = mknode($3.nd, $6.nd, "IF", ircode);
										ircode = ircode +"L"+to_string(iflastindex)+ ": " + $9.nd->code ;
										$$.nd = mknode(iff, $9.nd, "if-else-if", ircode,elseend);
										};


FUNCTIONCALL:
IDENTIFIER LPAREN PARAMS RPAREN {ircode =  "L" + string($1.name)+": "; $$.nd=mknode(NULL,NULL,$1.name, ircode);}|
MAIN LPAREN PARAMS RPAREN{ircode = "Lmain: "; $$.nd=mknode(NULL,NULL,$1.name, ircode);};

FUNCTIONDEF:
FUNCTION FUNCTIONCALL LCPAREN stment_seq RCPAREN {ircode = $2.nd->code + $4.nd->code + "return back \n";  $$.nd=mknode($4.nd, NULL, "Function", ircode); };

INCREMENT:
IDENTIFIER ASSIGN EXPR {ircode = string($1.name) + " += " + $3.nd->code + "\n"; $1.nd=mknode(NULL,NULL,$1.name, $1.name);$$.nd=mknode($1.nd,$3.nd,"ITERATOR", ircode);}|
IDENTIFIER INCONE { ircode = string($1.name) + " = " + string($1.name) + " + 1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR", ircode); }|
IDENTIFIER DECONE { ircode = string($1.name) + " = " + string($1.name) + " - 1" + "\n"; $1.nd = mknode(NULL, NULL, $1.name, $1.name); $2.nd = mknode(NULL, NULL, $2.name, $2.name); $$.nd = mknode($1.nd, $2.nd, "ITERATOR", ircode); };

Loop:
LOOP { add('K'); } LPAREN CONDITION RPAREN LCPAREN stment_seq RCPAREN LPAREN INCREMENT RPAREN { int loopstart,loopend;
											loopstart=irLabelCount++,loopend=irLabelCount++;
											ircode = "L"+to_string(loopstart)+": "+"IF_FALSE " + $4.nd->code +"GOTO L"+to_string(loopend)+"\n";
											 struct node *temp = mknode($4.nd, $10.nd, "CONDITION", ircode); 
											 ircode = ircode + $7.nd->code+ $10.nd->code + "\n GOTO L"+to_string(loopstart)+"\n L"+to_string(loopend)+": \n"; 
											 $$.nd = mknode(temp, $7.nd, $1.name, ircode);
											  }; 



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

void add_arr(char c, string sizeArr){
	q=search(yytext);
	if(q==0){
	if(c=='A'){
			symbolTable[count].id_name=strdup(yytext);
			symbolTable[count].data_type=strdup(sizeArr.c_str());
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

struct node* mknode(struct node *left, struct node *right, char *token, string code,int Label) {	
	// struct node *newnode = (struct node *)malloc(sizeof(struct node));
	struct node *newnode = new node;
	char *newstr = (char *)malloc(strlen(token)+1);
	// TODO: change token to string type
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	newnode->code = code;
	newnode->trueLabel = Label;
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

string findArrIndex(string code){
	string delimiter = " : ";
	int name_idx = code.find(delimiter);
	string arrName =  code.substr(0, name_idx);
	vector<int> array_dim = get_dim(code);
	vector<int> main_dim;
	// name_idx += 3;
	// vector<int> array_dim;
	// string dim="";

	// while(name_idx < code.size()){
	// 	if(code[name_idx]=='x'){
	// 		array_dim.push_back(stoi(dim));
	// 		dim = "";
	// 	}else{
	// 		dim += code[name_idx];
	// 	}
	// 	name_idx ++;
	// }
	// array_dim.push_back(stoi(dim));

	int i=0;

	for(i=0; i < count; i++){
		if(string(symbolTable[i].data_type).find(arrName + " :") != std::string::npos){
			main_dim = get_dim(string(symbolTable[i].data_type));
			
		}
	}
	for(int i=0;i<main_dim.size();i++){
		if(main_dim[i]<=array_dim[i]){

		}
	}

	return arrName;
}

vector<int> get_dim(string code){
	int name_idx = code.find(" : ");
	name_idx += 3;
	vector<int> array_dim;
	string dim="";

	while(name_idx < code.size()){
		if(code[name_idx]=='x'){
			array_dim.push_back(stoi(dim));
			dim = "";
		}else{
			dim += code[name_idx];
		}
		name_idx ++;
	}
	array_dim.push_back(stoi(dim));
	return array_dim;
}

int yyerror(char *s){
  std::cout<< "\n\nError: "<< s <<" in function "<< curr_function <<" in between lines "<< lines-1 <<" - " << lines+1 << std::endl;

}
