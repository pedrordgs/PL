%option noyywrap yylineno

%{
  #include <stdio.h>
  #include <string.h>
  char *name,*author,*email,*mode,*pwd;
%}

%%

\{%name%\} {printf(name);}
\{%author%\} {printf(author);}
\{%email%\} {printf(email);}
#[^\n]+ {if (strcmp(mode,"meta")!=0) ECHO;}
^===[ ](meta|tree) {ECHO;mode=strdup(yytext+4);}
^email:[  ][^\n]+ {ECHO;if (strcmp(mode,"meta")==0) email=strdup(yytext+7);}
^author:[  ][^\n]+ {ECHO;if (strcmp(mode,"meta")==0) author=strdup(yytext+8);}

%%

int main(int argc, char** argv){
  name = argv[1];
  yylex();
  return 0;
}
