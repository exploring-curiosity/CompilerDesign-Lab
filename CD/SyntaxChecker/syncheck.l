%{
#include<stdio.h>
#include<stdlib.h>
#include"y.tab.h"
void yyerror(char*);
extern int yylval;

%}


%%


[0-9]+ {
	yylval=atoi(yytext);
	return NUMBER;
}

for {return FOR;}

while {return WHILE;}

if  {return IF;}

else {return ELSE;}

[a-zA-Z_]([a-zA-z_]|[0-9])* {return ID;}

[{};()]  {return *yytext;}

[-+*/^()=&|%] {return *yytext;}

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
