GLIBFLAG = `pkg-config --cflags --libs glib-2.0`

install: filtro varchange

filtro:
	flex filtro.l
<<<<<<< HEAD
	gcc $(GLIBFLAG) lex.yy.c -o mktemplate -g -ggdb
=======
	gcc $(GLIBFLAG) lex.yy.c -o mktemplate
>>>>>>> 4a4327bc71d2ab3fef3bf5c13527e963d61693ec
	rm lex.yy.c

varchange:
	flex varchange.l
	gcc $(GLIBFLAG) lex.yy.c -o varchange
	rm lex.yy.c

clean:
	rm varchanged varchange mktemplate flex.fl flex.md README
	rm -rf doc - flex exemplo
