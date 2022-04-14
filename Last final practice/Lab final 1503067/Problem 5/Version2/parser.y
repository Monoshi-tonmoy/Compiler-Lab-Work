%{
	#include "symtab.c"
    #include "codeGen.h"
    #include "semantic.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* id;
 
}

%token<int_val> CHAR INT FLOAT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN PRINT DO DHORI RO LO SURU SESH   // a>>>2 type statements will match here and will generate MIPS
%token<int_val> ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP LT GT SUB GTE LTE PURNOSONGKHA
%token<int_val> LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER APOSTOPH
%token <id> ID
%token <int_val> 	 ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING

%left LPAREN RPAREN LBRACK RBRACK
%right NOTOP INCR REFER
%right MULOP DIVOP
%left ADDOP
%left RELOP
%left EQUOP
%left OROP
%left ANDOP
%right ASSIGN
%left COMMA

%type <int_val> constant names type expression declaration deep

%start program

%%

program:{gen_code(START, -1);} statements {gen_code(HALT, -1);};

statements: statements statement | ;

statement:ID LO expression
    {
        list_t* l=search($1->st_name);
        //printf("%s %d\n",$1->st_name, $1->st_type);

        printf("%d\n",l->address);

        gen_code(STORE,l->address);
        if(l == NULL)
        {
            printf("Not Defined\n");
        }

        else if(l->st_type==$3){
            printf("Valid assignment\n");
        }
        else{
            printf("Wrong assignment,type missmatch\n");
        }
        
    }
	| ID INCR SEMI
	{  
		list_t* l = search($1->st_name);


		printf("%s\n", $1->st_name);
        printf("here is the address %d\n",l->address);
        printf("here is the address %d\n",$1->address);


		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}


        
        {gen_code(LD_VAR,l->address); gen_code(LD_INT, 1); gen_code(ADD, -1); gen_code(STORE, l->address); }

	}
    | INCR ID SEMI;
    | declarations
    | ID RO PRINT
    {
			  int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(WRITE_INT, address);
			  else
			  	exit(1);
	};
    | if_statement
    | for_statement
    | while_statement
    | do_while_statement
;

if_statement: IF expression { if($2==GT) gen_code(JUMP_GT, 1); else if($2==LT) gen_code(JUMP_LT, 1); else if($2==GTE) gen_code(JUMP_GTE, 1);  else if($2==LTE) gen_code(JUMP_LTE, 1);} SURU statements {gen_code(GOTO,2);} SESH {gen_code(LABEL,1);} optional_else; //checking >,<,>=,<= operators and corresponding GT,GTE etc are envoked.


optional_else:  {gen_code(LABEL,2);}
                |ELSE LBRACE statements RBRACE {gen_code(LABEL,2);}
                |
                ELSE IF LPAREN expression RPAREN LBRACE statements RBRACE optional_else
                ;
 
for_statement: FOR LPAREN statement {gen_code(LABEL,5);} expression {if($5==GT) gen_code(JUMP_GT, 8); else if($5==LT) gen_code(JUMP_LT, 8); else if($5==GTE) gen_code(JUMP_GTE, 8);  else if($5==LTE) gen_code(JUMP_LTE,8);} SEMI {gen_code(GOTO,6); gen_code(LABEL,7);} expression {gen_code(GOTO,5);} RPAREN LBRACE {gen_code(LABEL,6);} statements {gen_code(GOTO,7);} RBRACE {gen_code(LABEL,8);}

while_statement:{gen_code(LABEL,3);} WHILE LPAREN expression RPAREN {if($4==GT) gen_code(JUMP_GT, 4); else if($4==LT) gen_code(JUMP_LT, 4); else if($4==GTE) gen_code(JUMP_GTE, 4);  else if($4==LTE) gen_code(JUMP_LTE, 4);} LBRACE statements{gen_code(GOTO,3);} RBRACE {gen_code(LABEL,4);} ;

do_while_statement : DO LBRACE { gen_code(LABEL, 9); } statements RBRACE WHILE LPAREN expression { if($8==GT) gen_code(JUMP_GT, 10); else if($8==LT) gen_code(JUMP_LT, 10); else if($8==GTE) gen_code(JUMP_GTE, 10);  else if($8==LTE) gen_code(JUMP_LTE, 10); gen_code(GOTO, 9); } RPAREN SEMI { gen_code(LABEL, 10); }; 

declarations: declarations declaration | ;

declaration: DHORI ID RO PURNOSONGKHA
			  {
        
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
			  | INT ID ASSIGN ICONST SEMI
			  {

                    insert($2->st_name, strlen($2->st_name), INT_TYPE);
                        list_t* l=search($2->st_name);
                        //printf("%s %d\n",$1->st_name, $1->st_type);

                        printf("Here is address:%d\n",l->address);
                        gen_code(LD_INT,$4);

                        gen_code(STORE,l->address);
			  }
                |FLOAT ID SEMI
               {

 
                
                insert($2->st_name, strlen($2->st_name), REAL_TYPE );
               }
            | FLOAT ID ASSIGN FCONST SEMI
			  {
    
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
                | INT ID ASSIGN FCONST SEMI
			  {
                  printf("Type mismatch\n");
			  }
              |
                CHAR ID ASSIGN CCONST SEMI
                {
                    insert($2->st_name, strlen($2->st_name), CHAR_TYPE);
                }
              | INT ID ASSIGN expression SEMI
              {
                  insert($2->st_name, strlen($2->st_name), INT_TYPE);
                  list_t* l=search($2->st_name);
                  gen_code(STORE,l->address);

              }

			;

names: ASSIGN expression 
{
	$$ = $2;
};

type: INT {$$=INT_TYPE;} | CHAR {$$=CHAR_TYPE;} | FLOAT {$$=REAL_TYPE;} | DOUBLE {$$=REAL_TYPE;} | VOID ;


constant: ICONST {$$=INT_TYPE;} | FCONST {$$=REAL_TYPE;} | CCONST {$$=CHAR_TYPE;} ;


expression:
    expression ADDOP deep { if($1 == $3 && $1!=VOID && $3!=VOID) { $$ = $1;} else { printf("Type Mismatch\n"); $$ = VOID; } gen_code(ADD,-1); } |

    expression MULOP expression { gen_code(MULT, -1); }|

    expression SUB deep {gen_code(SUBS,-1);} |
    
    ID INCR {  list_t* l=search($1->st_name); gen_code(LD_INT, 1); gen_code(ADD, -1); gen_code(STORE, l->address); } |
    INCR ID |
    expression OROP expression |
    expression ANDOP expression |
    NOTOP expression |
    expression EQUOP expression |
    expression GT expression { $$=GT;} |
    expression LT expression {$$=LT;} |
    expression GTE expression {$$=GTE;}|
    expression LTE expression {$$=LTE;}|  
    sign constant { $$=$2;} |
    ICONST { gen_code(LD_INT, $1);} |
	ID 
    {
        list_t* l=search($1->st_name);
        int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(LD_VAR, address);
			  else 
			  	exit(1);
        
        if(l == NULL)
        {
            printf("Not Declared--\n");
            $$ = VOID;
        }
        else
        {
            $$=l->st_type;
        }

        


    }
;

deep :  expression MULOP expression  { gen_code(MULT, -1); } | expression DIVOP expression { gen_code(DIV, -1);}| expression ;





sign: ADDOP | /* empty */ ;


%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	flag = yyparse();
	
	printf("Parsing finished!\n\n");
    symtab_data();
	
	// symbol table data
	// yyout = fopen("symtab_data.out", "w");
	// symtab_data(yyout);
	// fclose(yyout);





	printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");
	print_code();

	printf("\n\n================MIPS assembly================\n");
    print_assembly();


    freopen("test.s", "w", stdout);
    print_assembly();
	

    freopen("symtab_data.out","w",stdout);
    symtab_data();
	
	return flag;
}
