%{
    #include<stdio.h>
    void yyerror(char* s);
    int yylex();
%}

%token NUM ADD SUB MUL DIV EOL LB RB GT LT
%start cal

%%
cal:  cal exp EOL {printf(">%d\n>", $2);}
    | cal EOL {printf(">");};
    | /*epsilon*/
    ;

exp: factor
    | exp ADD factor {$$ = $1+$3;}
    | exp SUB factor {$$ = $1-$3; }
    | exp GT factor { if($1>$3) $$=1; else $$=0;}
    | exp LT factor { if($1>$3) $$=0; else $$=1;}
    
    ;


factor:term
    |factor MUL term{$$=$1*$3;}
    |factor DIV term{$$=$1/$3;}
    ;

term:LB exp RB {$$=$2;}
    |NUM
    
;
%%

int main()
{
    printf(">");
    yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
