install: filtro varchange

filtro:
	flex filtro.l
	gcc lex.yy.c -o mktemplate
	rm lex.yy.c

varchange:
	flex varchange.l
	gcc lex.yy.c -o varchange
	rm lex.yy.c

clean:
	rm varchanged varchange mktemplate flex.fl flex.md README
	rm -rf doc - flex exemplo
