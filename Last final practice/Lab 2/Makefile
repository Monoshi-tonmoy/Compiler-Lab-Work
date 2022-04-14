input=input.c
output=output.txt

main: lexer.l 
	flex lexer.l
	gcc lex.yy.c
	./a.out <$(input)> $(output)