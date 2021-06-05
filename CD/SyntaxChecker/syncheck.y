%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include"y.tab.h"
int yylex(void);
void yyerror(char *str);

%}


%token NUMBER OR AND NOT GTE LTE NE EQ LS RS FOR IF ELSE ID WHILE

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

S: ST{printf("\nNo Syntax Error\n");return 0;};

ST: FOR'('SA';'C';'E')'BLOCK 

|WHILE'('C')'BLOCK
;


BLOCK:'{'BODY'}'
|BODY
;


BODY:BODY BODY

|SA';' 

|IF'('C')'BLOCK ELSE BLOCK

|IF'('C')'BLOCK

|ST

|
;


SA:ID'='E

|E'+''+'

|E'-''-' 
;

E:E'+'E  

|E'-'E 

|E'*'E  

|E'/'E 

|E'%'E 

|E'^'E 

|'('E')' 

|E'&'E 

|E'|'E 

|E LS E 

|E RS E 

| '-' E 

|E'+''+'

|E'-''-'

|NUMBER

|ID 
; 

C:NOT E 
		
|E'<'E 
		
|E'>'E 

|E GTE E 
		
|E LTE E 
		
|E EQ E 

|E NE E 

|E AND E 
 
|E OR E 



%%
  
 
void yyerror(char *str)
{ 
   fprintf(stderr,"%s\n",str);
} 


void main() 
{ 
   yyparse(); 
} 
