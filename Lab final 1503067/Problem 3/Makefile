
main: cal.y cal.l
	bison -d cal.y  
	flex cal.l  
	gcc -o a.out cal.tab.c lex.yy.c  
	./a.out
