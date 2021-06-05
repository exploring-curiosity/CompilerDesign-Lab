%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include"y.tab.h"
int yylex(void);
void yyerror(char *str);

%}


%token NUMBER OR AND NOT GTE LTE NE EQ LS RS

%right '='

%left OR

%left AND

%left NOT

%left '|'

%left '&'

%left EQ NE

%left '<' '>' GTE LTE

%left LS RS
  
%left '+' '-' '%'
  
%left '*' '/'

%left '^'

%left '(' ')'


%%

Expression: E {
	printf("\nResult=%d\n", $$); 
	return 0; 
	}; 

E:E'+'E {$$=$1+$3;} 

|E'-'E {$$=$1-$3;} 

|E'*'E {$$=$1*$3;} 

|E'/'E {$$=$1/$3;}

|E'%'E {$$=$1%$3;} 

|E'^'E {$$=pow($1,$3);}

|'('E')' {$$=$2;} 

|NOT E {$$=(!$2);}
		
|E'<'E {$$=$1<$3;}
		
|E'>'E {$$=$1>$3;}
		
|E'&'E {$$=$1&$3;}

|E'|'E {$$=$1|$3;}

|E GTE E {$$=$1>=$3;}
		
|E LTE E {$$=$1<=$3;}
		
|E EQ E {$$=$1==$3;}

|E NE E {$$=$1!=$3;}

|E AND E {$$=$1&&$3;}

|E OR E {$$=$1||$3;}

|E LS E {$$=$1<<$3;}

|E RS E {$$=$1>>$3;}

| '-' E { $$ = (-($2));}

|NUMBER {$$=$1;} 
; 
  
%%
  
 
void yyerror(char *str)
{ 
   fprintf(stderr,"%s\n",str);
} 


void main() 
{ 
   yyparse(); 
} 
