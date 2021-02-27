### Pirlog Patricia 332CC - TemaB
build:
	lex tema.l
	gcc lex.yy.c

run:
	./a.out source-a.html source-b.html source-c.html myTest1.html myTest2.html

clear:
	rm a.out