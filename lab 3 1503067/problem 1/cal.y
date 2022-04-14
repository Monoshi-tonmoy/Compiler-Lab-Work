%{
    #include<stdio.h>
    void yyerror(char* s);
    int yylex();
%}

%token NUM ADD SUB MUL DIV EOL
%start cal

%%
cal:  cal exp EOL {printf(">%d\n>", $2);}
    | cal EOL {printf(">");};
    | /*epsilon*/
    ;

exp: factor
    | exp ADD factor {$$ = $1+$3;}
    | exp SUB factor {$$ = $1-$3; }
    ;


factor:term
    |factor MUL term{$$=$1*$3;}
    ;

term: NUM
    
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
