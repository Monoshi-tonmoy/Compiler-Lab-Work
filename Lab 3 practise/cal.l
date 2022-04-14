%option noyywrap

%{
    #include "cal.tab.h"
%}

delim [ \t]
ws ({delim})+
digit [0-9]
number ({digit})+

%%
{ws} {}
{number} {yylval = atoi(yytext); return NUM;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"(" {return LB; }
")" {return RB;}
">" {return GT;}
"<" {return LT;}
\n {return EOL; }
%%


