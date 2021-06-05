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

[\n] return 0;

. {yyerror("invalid case");}
%%

int yywrap(void)
{
	return 1;
} 
