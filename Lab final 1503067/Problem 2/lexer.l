 

%{
   char ch='%';
%}
ws[ \t]

%%
{ws} {}
[A-Za-z]*("Ami ki Flex k valobashi?")[A-Za-z]* { printf("50 %c valobasi 50 %c basi na\n",ch,ch);}  //matching here given string
[A-Za-z]* { printf("Valobashi na flex k\n"); }
\n { }
. { return 0; }

%%

int yywrap()
{
}

int main()
{
    yylex();
    
    return 0;
}
