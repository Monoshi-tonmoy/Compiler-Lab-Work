%option noyywrap
%{

void print(char *s);

enum yytokentype
{
    INT=250,
    ID=251
};


%}

delim [ \t\n]
ws ({delim})+
letter [A-Za-z]
digit [0-9]
id (_|{letter})({letter}|{digit})*
number ({digit}+)
FCONST    "0"|{digit}*"."{digit}+

%%
{ws} {}
"int" {print("INT");}
{id} {print("ID");}
"(" {print("LP");}
")" {print("RP");}
"{" {print("LB");}
"}" {print("RB");}
"=" {print("ASSIGN");}
"+" {print("ADD");}
"++" {print("INCR");}
{number} {print("NUMBER");}
"if" {print("IF");}
";" {print("SCOLON");}
">" {print("CMP");}
{FCONST} {print("FLOAT");}
%%

void print(char *s)
{
    printf("%s %s\n", s, yytext);
}

int main()
{
    
    yylex();
    return 0;
}