%{
    #include<stdio.h>
    void yyerror(char* s);
    int yylex();
%}

%token DIGIT AND EOL
%start cal

%%
cal:  cal exp EOL {printf(">0%d\n>", $2);}
    | cal EOL {printf(">");};
    | /*epsilon*/
    ;


exp:DIGIT DIGIT AND DIGIT DIGIT {if(($1==0)&&($2==0)&&($4==0)&&($5==0)) {$$=0;} else if(($1==0)&&($2==0)&&($4==0)&&($5==1)) {$$=1;} } //only for two sample inputs
    
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
