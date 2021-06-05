%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	void yyerror(char *str);
	int t=1,r=0;
	char otemp[100],gtemp[100];
	void getOptCode(char *optcode,char *p,char *v1,char *op,char *v2);
	void GenCode(char *out,char *p,char *v1,char *op,char *v2);
	struct data {
		char *var;
		char *code;
		char *opt;
		char *gen;
	};
%}

%token ID IF ELSE FOR CONSTANT 

%union{
	struct data info;
	int val;
}

%type<info> E ID ST ASSIGN
%type<val> CONSTANT

%left '*' '/'
%right '+' '-'

%%
S:ST {
		printf("\n\n-----------------------------------------------------\n");
		printf("\n\nTracing Completed : No Syntax Error\n\n");
		printf("-----------------------------------------------------\n");
		printf("Intermediate Code:\n\n%s\n\n",$1.code);
		printf("-----------------------------------------------------\n");
		printf("Optimized Code:\n\n%s\n\n",$1.opt); 
		printf("-----------------------------------------------------\n");
		printf("Generated Code:\n\n%s\n\n",$1.gen);
		printf("-----------------------------------------------------\n");
	};

ST:ST ST {
			$$.code=(char*)malloc(1000);
			sprintf($$.code,"%s%s",$1.code,$2.code);
			$$.opt=(char*)malloc(1000);
			sprintf($$.opt,"%s%s",$1.opt,$2.opt);
			$$.gen=(char*)malloc(1000);
			sprintf($$.gen,"%s%s",$1.gen,$2.gen);
		 }
|ASSIGN {
			$$.code=(char*)malloc(1000);
			sprintf($$.code,"%s",$1.code);
			$$.opt=(char*)malloc(1000);
			sprintf($$.opt,"%s",$1.opt);
			$$.gen=(char*)malloc(1000);
			sprintf($$.gen,"%s",$1.gen);
		}
|		{
			$$.code=(char*)malloc(1000);
			strcpy($$.code,"");
			$$.opt=(char*)malloc(1000);
			strcpy($$.opt,"");
			$$.gen=(char*)malloc(1000);
			strcpy($$.gen,"");
		}
;

ASSIGN:ID '=' E 	{
						$$.code=(char*)malloc(1000);
						sprintf($$.code,"%s%s=%s\n",$3.code,$1.var,$3.var);
						$$.opt=(char*)malloc(1000);
						sprintf($$.opt,"%s%s=%s\n",$3.opt,$1.var,$3.var);
						$$.gen=(char*)malloc(1000);
						sprintf($$.gen,"%sMOV %s,%s\n",$3.gen,$3.var,$1.var);
					}
;

E:E '+' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s%s=%s+%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			getOptCode(otemp,$$.var,$1.var,"+",$3.var);
			sprintf($$.opt,"%s%s%s\n",$1.opt,$3.opt,otemp);
			$$.gen=(char*)malloc(1000);
			GenCode(gtemp,$$.var,$1.var,"+",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gtemp);
		  }
|E '-' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s%s=%s-%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			getOptCode(otemp,$$.var,$1.var,"-",$3.var);
			sprintf($$.opt,"%s%s%s\n",$1.opt,$3.opt,otemp);
			$$.gen=(char*)malloc(1000);
			GenCode(gtemp,$$.var,$1.var,"-",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gtemp);
		  }
|E '*' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s%s=%s*%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			getOptCode(otemp,$$.var,$1.var,"*",$3.var);
			sprintf($$.opt,"%s%s%s\n",$1.opt,$3.opt,otemp);
			$$.gen=(char*)malloc(1000);
			GenCode(gtemp,$$.var,$1.var,"*",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gtemp);
		  }
|E '/' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s%s=%s/%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			getOptCode(otemp,$$.var,$1.var,"/",$3.var);
			sprintf($$.opt,"%s%s%s\n",$1.opt,$3.opt,otemp);
			$$.gen=(char*)malloc(1000);
			GenCode(gtemp,$$.var,$1.var,"/",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gtemp);
		  }

|ID {
		$$.code=(char*)malloc(1);
		$$.var=(char*)malloc(10);
		sprintf($$.var,"%s",$1.var);
		strcpy($$.code,"");
		$$.opt=(char*)malloc(1000);
		strcpy($$.opt,"");
		$$.gen=(char*)malloc(1000);
		strcpy($$.gen,"");
	}
|CONSTANT {
			$$.code=(char*)malloc(1);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"%d",$1);
			strcpy($$.code,"");
			$$.opt=(char*)malloc(1000);
			strcpy($$.opt,"");
			$$.gen=(char*)malloc(1000);
			strcpy($$.gen,"");
		}
;
%%

void getOptCode(char *optcode,char *p,char *v1,char *op,char *v2)
{	
	if(!strcmp(op,"+"))
	{
		if(!strcmp(v1,"0"))
			sprintf(optcode,"%s=%s",p,v2);
		else if(!strcmp(v2,"0"))
			sprintf(optcode,"%s=%s",p,v1);
		else
			sprintf(optcode,"%s=%s%s%s",p,v1,op,v2);
	}
	else if(!strcmp(op,"*"))
	{
		if(!strcmp(v1,"1"))
			sprintf(optcode,"%s=%s",p,v2);
		else if(!strcmp(v2,"1"))
			sprintf(optcode,"%s=%s",p,v1);
		else
			sprintf(optcode,"%s=%s%s%s",p,v1,op,v2);
	}
	else if(!strcmp(op,"/"))
	{
		if(!strcmp(v2,"1"))
			sprintf(optcode,"%s=%s",p,v1);
		else
			sprintf(optcode,"%s=%s%s%s",p,v1,op,v2);
	}
	else if(!strcmp(op,"-"))
	{
		if(!strcmp(v1,"0"))
			sprintf(optcode,"%s=-%s",p,v2);
		else if(!strcmp(v2,"0"))
			sprintf(optcode,"%s=%s",p,v1);
		else
			sprintf(optcode,"%s=%s%s%s",p,v1,op,v2);
	}
}
void GenCode(char *out,char *p,char *v1,char *op,char *v2)
{	
	char mv1[10],mv2[10];
	if(v1[0]>='0' && v1[0]<='9')
	{
		mv1[0]='#';
		mv1[1]='\0';
		strcat(mv1,v1);
	}
	else
	{
		strcpy(mv1,v1);
	}
	if(v2[0]>='0' && v2[0]<='9')
	{
		mv2[0]='#';
		mv2[1]='\0';
		strcat(mv2,v2);
	}
	else
	{
		strcpy(mv2,v2);
	}
	if(!strcmp(op,"+"))
	{
		if(!strcmp(v1,"0"))
			sprintf(out,"MOV %s,%s\n",mv2,p);
		else if(!strcmp(v2,"0"))
			sprintf(out,"MOV %s,%s\n",mv1,p);
		else
		{
			if(!strcmp(op,"+"))
			{
				sprintf(out,"MOV %s,R%d\nADD %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"-"))
			{
				sprintf(out,"MOV %s,R%d\nSUB %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"*"))
			{
				sprintf(out,"MOV %s,R%d\nMUL %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"/"))
			{
				sprintf(out,"MOV %s,R%d\nDIV %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			r+=1;
		}
	}
	if(!strcmp(op,"*"))
	{
		if(!strcmp(v1,"1"))
			sprintf(out,"MOV %s,%s\n",mv2,p);
		else if(!strcmp(v2,"1"))
			sprintf(out,"MOV %s,%s\n",mv1,p);
		else
		{
			if(!strcmp(op,"+"))
			{
				sprintf(out,"MOV %s,R%d\nADD %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"-"))
			{
				sprintf(out,"MOV %s,R%d\nSUB %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"*"))
			{
				sprintf(out,"MOV %s,R%d\nMUL %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"/"))
			{
				sprintf(out,"MOV %s,R%d\nDIV %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			r+=1;
		}
	}
	if(!strcmp(op,"/"))
	{
		if(!strcmp(v2,"1"))
			sprintf(out,"MOV %s,%s\n",mv1,p);
		else
		{
			if(!strcmp(op,"+"))
			{
				sprintf(out,"MOV %s,R%d\nADD %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"-"))
			{
				sprintf(out,"MOV %s,R%d\nSUB %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"*"))
			{
				sprintf(out,"MOV %s,R%d\nMUL %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"/"))
			{
				sprintf(out,"MOV %s,R%d\nDIV %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			r+=1;
		}
	}
	if(!strcmp(op,"-"))
	{
		if(!strcmp(v1,"0"))
		{
			sprintf(out,"MOV %s,R%d\nNEG R%d\nMOV R%d,%s\n",mv2,r,r,r,p);
			r+=1;
		}
		else if(!strcmp(v2,"0"))
			sprintf(out,"MOV %s,%s\n",mv1,p);
		else
		{
			if(!strcmp(op,"+"))
			{
				sprintf(out,"MOV %s,R%d\nADD %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"-"))
			{
				sprintf(out,"MOV %s,R%d\nSUB %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"*"))
			{
				sprintf(out,"MOV %s,R%d\nMUL %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			else if(!strcmp(op,"/"))
			{
				sprintf(out,"MOV %s,R%d\nDIV %s,R%d\nMOV R%d,%s\n",mv1,r,mv2,r,r,p);
			}
			r+=1;
		}
	}
}

void yyerror(char *str)
{ 
   	fprintf(stderr,"%s\n",str);
} 


void main() 
{ 
	printf("\n\n-----------------------------------------------------\n");
   	printf("Lexical Analyser :\n\n");
   	yyparse(); 
} 