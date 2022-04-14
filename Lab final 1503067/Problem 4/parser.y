%{
	#include "symtab.c"
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

%token<int_val> CHAR INT FLOAT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN
%token<int_val> ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP RELOP
%token<int_val> LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER APOSTOPH
%token <id> ID
%token <int_val> 	 ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING

%left LPAREN RPAREN LBRACK RBRACK
%right NOTOP INCR REFER
%left MULOP DIVOP
%left ADDOP
%left RELOP
%left EQUOP
%left OROP
%left ANDOP
%right ASSIGN
%left COMMA

%type <int_val> constant names type expression declaration

%start program

%%

program: statements;

statements: statements statement | ;

statement: ID ASSIGN expression SEMI 
    {
        printf("------------Checking assignments----------\n"); //checking d=a*b; and d=a*b+c type validation here
        list_t* l=search($1->st_name);
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


		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}

	}
    | INCR ID SEMI;
    | declarations
    | if_statement
    | for_statement
    | while_statement
;

if_statement: IF LPAREN expression RPAREN LBRACE statements RBRACE optional_else;

optional_else: |
               ELSE LBRACE statements RBRACE
                |
                ELSE IF LPAREN expression RPAREN LBRACE statements RBRACE optional_else
                ;
 
for_statement: FOR LPAREN statement expression SEMI expression RPAREN LBRACE statements RBRACE ;

while_statement: WHILE LPAREN expression RPAREN LBRACE statements RBRACE ;

declarations: declarations declaration | ;

declaration: INT ID SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
			  | INT ID ASSIGN ICONST SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
              | INT ID ASSIGN FCONST SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
                  printf("Type missmatch,inserting double value in integer variable\n"); //checing type missmatch
			  }
              | DOUBLE ID ASSIGN FCONST SEMI
                {
                    insert($2->st_name, strlen($2->st_name),REAL_TYPE);
                }

                |FLOAT ID SEMI
               {
                insert($2->st_name, strlen($2->st_name), REAL_TYPE );
               }
               |DOUBLE ID SEMI
               {
                insert($2->st_name, strlen($2->st_name), REAL_TYPE );
               }
            | FLOAT ID ASSIGN FCONST SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
            | DOUBLE ID ASSIGN ICONST SEMI
                {
                    insert($2->st_name, strlen($2->st_name),REAL_TYPE);
                    printf("Type missmatch,inserting int value in double variable\n"); //checking type missmatch
                }
              |
                CHAR ID ASSIGN CCONST SEMI
                {
                    insert($2->st_name, strlen($2->st_name), CHAR_TYPE);
                }
                 | INT ID ASSIGN expression SEMI
			  {
                  if($4 == VOID)
                  {
                    printf("Can't assign\n");
                   }
                    else
                    {
                        insert($2->st_name, strlen($2->st_name), INT_TYPE);
                    }
				  
			  }

			;

type: INT {$$=INT_TYPE;} | CHAR {$$=CHAR_TYPE;} | FLOAT {$$=REAL_TYPE;} | DOUBLE {$$=REAL_TYPE;} | VOID ;

names: ASSIGN expression 
{
	$$ = $2;
};

constant: ICONST {$$=INT_TYPE;} | FCONST {$$=REAL_TYPE;} | CCONST {$$=CHAR_TYPE;} ;

 //form here type of the expression is passing
expression: 
    expression ADDOP expression { if($1 == $3 && $1!=VOID && $3!=VOID) { $$ = $1;} else {  $$ = VOID; } } |
    expression MULOP expression  { if($1 == $3 && $1!=VOID && $3!=VOID) { $$ = $1;} else {  $$ = VOID; } }|
    expression DIVOP expression |
    ID INCR |
    INCR ID |
    expression OROP expression |
    expression ANDOP expression |
    NOTOP expression |
    expression EQUOP expression |
    expression RELOP expression |
    LPAREN expression RPAREN |
    sign constant { $$=$2;} |
	ID 
    {
        //returning identifier type
        list_t* l=search($1->st_name);
        if(l == NULL)
        {
            $$ = VOID;
        }
        else
        {
            $$=l->st_type;
        }

        


    }
;

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

    printf("Here is the symbol table\n\n\n");
    symtab_data();
	
	return flag;
}
