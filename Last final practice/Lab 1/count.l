 

%{
   int count=0;
   int sum=0;
%}

%%
[0-9] {sum+=yytext[0]-48; }
[^0-9,\n] {printf("Invalid input\n"); return 0; }
\n { return 0;}
%%

int yywrap()
{
}

int main()
{
 yylex();
 printf("Sum of the digits= %d\n", sum);

 return 0;
}