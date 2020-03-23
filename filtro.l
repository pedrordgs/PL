%option noyywrap yylineno

%x META TREE
%{
  #include <stdio.h>
  #include <string.h>
  char *name,*author,*email,*file,*pwd;
  int mkdir (char* path);
  int mkfile (char* path);
  int writef (char* s, char* f);
%}

%%

^===[  ]meta {printf("Inicio de metadados\n");BEGIN META;}
<META>^email:[  ][^\n]+ {email=strdup(yytext+7);}
<META>^author:[  ][^\n]+ {author=strdup(yytext+8);}
<META>^===[  ]tree {printf("Inicio de arvore ficheiros\n");BEGIN TREE;}
<TREE>^[^\n]+\/$ {mkdir(yytext);}
<TREE>^[^\n]+ {mkfile(yytext);}
<TREE>^===[  ][^\n]+ {printf("Ficheiro para escrita\n");file=strdup(yytext+4);BEGIN INITIAL;}
^===[  ][^\n]+ {printf("Ficheiro para escrita\n");file=strdup(yytext+4);}
^[^\n]+ {writef(yytext,file);}
.|\n {;}
%%

int mkdir (char* path){
  char i [sizeof(char)*strlen(path)+10];
  sprintf(i,"mkdir %s",path);
  system(i);
  return 0;
}

int mkfile (char* path){
  char i [sizeof(char)*strlen(path)+10];
  sprintf(i,"touch %s",path);
  system(i);
  return 0;
}

int writef (char* s, char* f){
  char i [sizeof(char)*strlen(s)+10+sizeof(char)*strlen(f)];
  sprintf(i,"echo %s >> %s",s,f);
  system(i);
  return 0;
}

int main(int argc, char** argv){
  name = argv[1];
  yylex();
  return 0;
}
