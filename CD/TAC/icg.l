%{
#include<stdio.h>
#include<stdlib.h>

struct data{
		int val;
		char *code;
		char *var;
};
#include"y.tab.h"
extern YYSTYPE yylval;
void yyerror(char*);
%}


%%


[-+]?[0-9]+ {
	yylval.val=atoi(yytext);
	return NUMBER;
}

[-+]?[0-9]*[.][0-9]+ {
	yylval.val=atoi(yytext);
	return NUMBER;
}

for {return FOR;}

while {return WHILE;}

if  {return IF;}

then {return THEN;}

else {return ELSE;}

end_if {return ENDIF;}

integer {return INT;}

real {return REAL;}

char {return CHAR;}

begin {return BEG;}

end	{return END;}

var {return VAR;}

['].['] {yylval.val=(int)yytext[1];return NUMBER;}

[a-zA-Z_]([a-zA-z_]|[0-9])* {yylval.info.var=(char*)malloc(10);strcpy(yylval.info.var,yytext);return ID;}

[{};()]  {return *yytext;}

[-+*/^()=&|%:] {return *yytext;}

"<"|">" {return *yytext;}

">=" {return GTE;}

"<=" {return LTE;}

"!=" {return NE;}

"==" {return EQ;}

"&&" {return AND;}

"||" {return OR;}

"!"  {return NOT;}

"<<" {return LS;}

">>" {return RS;}
 
[\t] ;

[\n] ;

[ ] ;

. {yyerror("invalid case");}
%%

int yywrap(void)
{
	return 1;
} 
