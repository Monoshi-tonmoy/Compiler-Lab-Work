%option noyywrap

%{
    #include "cal.tab.h"
%}

delim [ \t]
ws ({delim})+
digit [0-9]

%%
{ws} {}
{digit} {yylval = atoi(yytext); return DIGIT;}
"&" {return AND;}
\n {return EOL; }
%%


