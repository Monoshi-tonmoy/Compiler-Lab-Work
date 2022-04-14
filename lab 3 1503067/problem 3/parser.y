%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	extern int lineno;
    int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
}

/* token definition */
%token CHAR INT FLOAT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN MAIN
%token ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP RELOP
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER
%token ID
%token <int_val> 	 ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING


%start program

%%

program: main
		;
main: INT MAIN LPAREN RPAREN  LBRACE statements RBRACE 
		;

statements: statements statement 
			| /*epsilon*/
			;

if_statement: IF LPAREN expression RPAREN tail optional_else_if
            | IF LPAREN expression RPAREN tail optional_else
			;

optional_else_if: ELSE IF LPAREN expression RPAREN tail optional_else
				| /* epsilon */
				;
tail: LBRACE statements RBRACE
			;


while_statement: WHILE LPAREN expression RPAREN tail
			;

statement: if_statement 
		 | while_statement
		 | ID ASSIGN expression SEMI 
		 | type ID SEMI 
		 | type ID ASSIGN expression SEMI 
		 | ID INCR SEMI
		 | type ID ASSIGN ID INCR SEMI
		 | ID ASSIGN ID INCR SEMI
         | ID ASSIGN ID ADDOP FCONST SEMI
		 ;

type: INT 
	| CHAR 
	| FLOAT 
	| DOUBLE 
	| VOID ;



optional_else: ELSE tail 
			  | /* epsilon */
			  ;

constant: ICONST 
		| CCONST 
		| FCONST 
		;

expression: expression ADDOP expression
		  | expression OROP expression
		  | expression ANDOP expression
		  | expression EQUOP expression
		  | expression RELOP expression
		  | constant 
		  | ID
		  |
		  ;

%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	yyparse();

	printf("Parsing finished!");
}
