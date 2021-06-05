%{
	#include<stdio.h>
	#include<string.h>
	int multi_flag=0,count=0,addr=2000,assign=0,id_flag=0,dec=0;
	char cur_type[20];

	struct symTable{
		char sym[20];
		int address;
		char type[20];
		char value[20];
		int size;
	}tab[10];
	void constab(char*);
	void reset_flag();
	void update(char*);
%}


numberC ([0-9]+)|([0-9]*(\.)[0-9]+)
charC '(.)'
stringC \"((.)*)\"
relop ("<"|"<="|"=="|"!="|">"|">=")
arithop ("+"|"-"|"*"|"/"|"%")
logop ("&&"|"||"|"!")
assign "="
multi_s \/\*
multi_e \*\/
single "//".*
SP \(|\)|\{|\}|","|";"
KW if|else|while|do|for|break|continue|switch
data_type int|float|char|double
function ([ _ a-z A-Z ])([ _ a-z A-Z 0-9 ])*\((.)*\)
id ([_a-zA-Z])([_a-zA-Z0-9])*
newline "\n"
%%

{numberC} {if(!multi_flag) printf("NUMCONST ");if(assign==1){update(yytext);reset_flag();}}
{charC} {if(!multi_flag) printf("CHARCONST ");if(assign==1){update(yytext);reset_flag();}}
{stringC} {if(!multi_flag) printf("STRCONST ");if(assign==1){update(yytext);reset_flag();}}
{relop} {if(!multi_flag) printf("RELOP ");reset_flag();}
{arithop} {if(!multi_flag) printf("ARITHOP ");reset_flag();}
{logop} {if(!multi_flag) printf("LOGOP ");reset_flag();}
{assign} {if(!multi_flag) printf("ASSIGN "); if(id_flag==1) assign=1; }
{multi_s} {if(!multi_flag) printf("MULTI_S ");multi_flag=1;reset_flag();}
{multi_e} {multi_flag=0;if(!multi_flag) printf("MULTI_E "); reset_flag();}
{single} {if(!multi_flag) printf("SINGLE ");reset_flag();}
{SP} {if(!multi_flag) printf("SP ");reset_flag();}
{KW} {if(!multi_flag) printf("KW "); reset_flag();}
{data_type} {if(!multi_flag) printf("KW"); strcpy(cur_type,yytext); dec=1; }
{function} {if(!multi_flag) printf("FN ");reset_flag();}
{newline} {if(!multi_flag) printf("\n"); dec=0;}
{id} {if(!multi_flag) printf("ID "); if(dec==1){constab(yytext); id_flag=1;}}
%%
void main()
{
	int i;
	FILE *fp = fopen("test_file1.c", "r");
	if(fp == NULL)
   	{
    	perror("Unable to open file!");
    	exit(1);
	}
	yyin=fp;
	yylex();
	printf("\nNAME  TYPE  SIZE ADDR VALUE\n");
	for(i=0;i<count;i++)
	{
		printf("%4s %6s %4d %4d %s\n",tab[i].sym,tab[i].type,tab[i].size,tab[i].address,tab[i].value);
	}
}
void update(char* val)
{
	strcpy(tab[count-1].value,val);
}
void reset_flag()
{
	assign=0;
	id_flag=0;
}
void constab(char* id)
{
	strcpy(tab[count].sym,id);
	strcpy(tab[count].type,cur_type);
	tab[count].address=addr;
	if(!strcmp(cur_type,"int"))
	{
		addr+=2;
		tab[count].size = 2;
		
	}
	else if(!strcmp(cur_type,"float"))
	{
		
		addr+=4;
		tab[count].size =4;
	}	
	else if(!strcmp(cur_type,"char"))
	{
		addr+=1;
		tab[count].size =1;
	}
	else if(!strcmp(cur_type,"double"))
	{
		addr+=8;
		tab[count].size =8;
	}

	count++;
	update("-");
}
int yywrap(void){}

/*
MULTI_S 
    
  
MULTI_E 
FN 
SP 
KW  ID ASSIGN NUMCONST SP ID ASSIGN NUMCONST SP 
SINGLE 
KW 'SP ID RELOP ID SP 
FN SP 
KW 
FN SP 
SP 

FN 
SP 
SP
*/