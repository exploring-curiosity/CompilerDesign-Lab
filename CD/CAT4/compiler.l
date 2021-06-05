%{
	#include<stdio.h>
	#include<stdlib.h>
	struct data {
		char *var;
		char *code;
		char *opt;
		char *gen;
	};
	#include"y.tab.h"
	void yyerror(char*);
	extern YYSTYPE yylval;
	int n=0;
	char ER[100];
%}
%%

[0-9]+ {yylval.val=atoi(yytext); printf("CONSTANT"); return CONSTANT;}

[a-zA-Z_][a-zA-Z0-9_]* {printf("ID"); yylval.info.var=(char*)malloc(10);strcpy(yylval.info.var,yytext); return ID;}

[=] {printf("ASSIGNOP"); return *yytext;}

[+-/] { printf("ARITHOP");  return *yytext;}

\* { printf("ARITHOP");  return *yytext;}

[ \t] {printf("%s",yytext);}

[\n] {n++;printf("\n");}

. {sprintf(ER,"error in line %d",n);yyerror(ER);}
%%

int yywrap(void)
{
	return 1;
}
