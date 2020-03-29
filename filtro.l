%option noyywrap yylineno

%x META TREE
%{
#include <stdio.h>
#include <string.h>
#include <glib.h>

typedef struct node{
    char* descricao;
    int file;
}Node;

GNode *dirs,*parent;
int prof=0,nprof=0;
char *name,*author,*email,*file,*pwd;

GNode* addToTree (char* nome, int file, GNode* parent);
int mkdir (char* path);
int mkfile (char* path);
int writef (char* s, char* f);
%}

%%

^===[  ]meta                        {BEGIN META;}
<META>{
^email:[  ][^\n]+                   {email=strdup(yytext+7);}
^author:[  ][^\n]+                  {author=strdup(yytext+8);}
^===[  ]tree                        {BEGIN TREE;}
.|\n                                {;}
}
<TREE>{
^===[  ][^\n]+                      {/*file=strdup(yytext+4);*/BEGIN 0;}
^-+[  ]                             {printf(yytext);nprof=strlen(yytext)-1;}
[a-zA-Z0-9._ ]+\/$                  {
                                        while(nprof!=prof){
                                        parent=parent->parent;
                                        prof--;
                                        }
                                        parent=addToTree(yytext,0,parent);
                                        prof++;
                                        nprof=0;
                                    }
[a-zA-Z0-9._ ]+                     {
                                        while(nprof!=prof){
                                        parent=parent->parent;
                                        prof--;
                                        }
                                        addToTree(yytext,1,parent);
                                        nprof=0;
                                    }
.|\n                                {;}
}
^===[ ][^\n]+                       {file=strdup(yytext+4);}
^[^\n]+                             {;/*{writef(yytext,file);}*/}
.|\n                                {;}

%%

GNode* addToTree(char* nome, int file, GNode* parent){
    Node* new = malloc(sizeof(struct node));
    new->descricao = strdup(nome);
    new->file = file;
    GNode* node;
    if (parent==NULL){
        node = g_node_new(new);
        g_node_append(dirs,node);
    }
    else{
        node = g_node_new(new);
        g_node_append(parent,node);
    }
    return node;
}

void initializeTree(){
    dirs = g_node_new(NULL);
}


void transformTree (GNode* dir,char* path){
    if (dir!=NULL){
        GNode* child = g_node_first_child(dir);
        char command [1024];
        while(child){
            Node* dados = child->data;
            if (dados->file) sprintf(command,"touch %s%s",path,dados->descricao);
            else sprintf(command,"mkdir %s%s",path,dados->descricao);
            system(command);
            if (!dados->file){
                sprintf(command,"%s%s",path,dados->descricao);
                transformTree(child,command);
            }
            child=child->next;
        }
    }
}


/* gboolean tfunc (GNode* node, gpointer data){ */
/*     GNode* pai = node->parent; */
/*     if (pai!=NULL){ */
/*         Node* dados = node->data; */
/*         printf("Nome: %s   %d   ",dados->descricao,dados->file); */
/*         Node* dados_pai; */
/*         dados_pai = pai->data; */
/*         if (dados_pai!=NULL) */
/*             printf("Pai: %s\n",dados_pai->descricao); */
/*         else */
/*             printf("Pai: Root\n"); */
/*     } */
/*     return FALSE; */
/* } */

/* void navigateTree (){ */
/*     g_node_traverse(dirs,G_LEVEL_ORDER,G_TRAVERSE_ALL,-1,tfunc,NULL); */
/* } */


int writef (char* s, char* f){
    char i [sizeof(char)*strlen(s)+10+sizeof(char)*strlen(f)];
    sprintf(i,"echo %s >> %s",s,f);
    system(i);
    return 0;
}

int main(int argc, char** argv){
    name = argv[1];
    initializeTree();
    yylex();
    /* navigateTree(); */
    transformTree(dirs,"~/miei/3ano/pl/trabalho/");
    return 0;
}




