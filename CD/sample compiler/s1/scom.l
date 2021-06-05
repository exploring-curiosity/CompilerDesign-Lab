%{
	#include<stdio.h>
	#include<stdlib.h>
	struct data {
		char *var;
		char *code;
		char *opt;
	};
	#include"y.tab.h"
	void yyerror(char*);
	extern YYSTYPE yylval;
	int n=0;
	char errorSt[100];
%}
%%

[0-9]+ {yylval.val=atoi(yytext); printf("Num"); return NUMBER;}
[a-zA-Z_][a-zA-Z0-9_]* {printf("ID"); yylval.info.var=(char*)malloc(10);strcpy(yylval.info.var,yytext); return ID;}
[=+-/] { printf("%s",yytext); return ARITHOP;}
\* { printf("*");return ARITHOP;}
[ \t] {printf("%s",yytext);}
[\n] {n++;printf("\n");}
. {sprintf(errorSt,"error in line %d",n);yyerror(errorSt);}
%%

int yywrap(void)
{
	return 1;
}
