%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	void yyerror(char *str);
	struct data {
		char *var;
		char *code;
		char *opt;
		char *gen;
	};
	int label=1,t=1,r=0;
	char optcode[100];
	char gencode[100];
	void Optimize(char *out,char *lhs,char *v1,char *op,char *v2);
	void GenCode(char *out,char *lhs,char *v1,char *op,char *v2);
%}

%token ID IF ELSE FOR NUMBER

%union{
	struct data info;
	int val;
}

%type<info> E ID ST ASSIGN COND BLOCK BODY C
%type<val> NUMBER

%%
S:ST {printf("\n\nSyntax Checking : No Syntax Error\n\n");printf("Intermediate Code:\n\n%s\n\n",$1.code); printf("Optimized Code:\n\n%s\n\n",$1.opt); printf("Generated Code:\n\n%s\n\n",$1.gen);};

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
|COND 	{	
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

ASSIGN:ID '=' E ';' {
						$$.code=(char*)malloc(1000);
						sprintf($$.code,"%s   %s=%s\n",$3.code,$1.var,$3.var);
						$$.opt=(char*)malloc(1000);
						sprintf($$.opt,"%s   %s=%s\n",$3.opt,$1.var,$3.var);
						$$.gen=(char*)malloc(1000);
						sprintf($$.gen,"%s   MOV %s,%s\n",$3.gen,$3.var,$1.var);
					}
;

COND:IF '(' C ')' BLOCK ELSE BLOCK {
										$$.code=(char*)malloc(1000);
										sprintf($$.code,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%s   GOTO L%d\nL%d:%sL%d:\n",$3.code,label,label+1,label,$5.code,label+2,label+1,$7.code,label+2);
									
										$$.opt=(char*)malloc(1000);
										sprintf($$.opt,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%s   GOTO L%d\nL%d:%sL%d:\n",$3.code,label,label+1,label,$5.opt,label+2,label+1,$7.opt,label+2);

										$$.gen=(char*)malloc(1000);
										sprintf($$.gen,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%s   GOTO L%d\nL%d:%sL%d:\n",$3.code,label,label+1,label,$5.gen,label+2,label+1,$7.gen,label+2);
										label+=3;
								   }
|IF '(' C ')' BLOCK {
						$$.code=(char*)malloc(1000);
						sprintf($$.code,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%sL%d:",$3.code,label,label+1,label,$5.code,label+1);
						
						$$.opt=(char*)malloc(1000);
						sprintf($$.opt,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%sL%d:",$3.code,label,label+1,label,$5.opt,label+1);

						$$.gen=(char*)malloc(1000);
						sprintf($$.gen,"   IF (%s) GOTO L%d\n   GOTO L%d\nL%d:%sL%d:",$3.code,label,label+1,label,$5.gen,label+1);
						label+=2;
					}
;


BLOCK:'{' BODY '}'  {
						$$.code=(char*)malloc(1000);
						sprintf($$.code,"%s",$2.code);
						$$.opt=(char*)malloc(1000);
						sprintf($$.opt,"%s",$2.opt);
						$$.gen=(char*)malloc(1000);
						sprintf($$.gen,"%s",$2.gen);
					}
|BODY {
		$$.code=(char*)malloc(1000);
		sprintf($$.code,"%s",$1.code);
		$$.opt=(char*)malloc(1000);
		sprintf($$.opt,"%s",$1.opt);
		$$.gen=(char*)malloc(1000);
		sprintf($$.gen,"%s",$1.gen);
	  }
;

BODY:BODY BODY  {
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
|COND	{
			$$.code=(char*)malloc(1000);
			sprintf($$.code,"%s",$1.code);
			$$.opt=(char*)malloc(1000);
			sprintf($$.opt,"%s",$1.opt);
			$$.gen=(char*)malloc(1000);
			sprintf($$.gen,"%s",$1.gen);
		}
| {
	$$.code=(char*)malloc(1000);
	strcpy($$.code,"");
	$$.opt=(char*)malloc(1000);
	strcpy($$.opt,"");
	$$.gen=(char*)malloc(1000);
	strcpy($$.gen,"");
  }
;


E:E '+' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s   %s=%s+%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			Optimize(optcode,$$.var,$1.var,"+",$3.var);
			sprintf($$.opt,"%s%s   %s\n",$1.opt,$3.opt,optcode);
			$$.gen=(char*)malloc(1000);
			GenCode(gencode,$$.var,$1.var,"+",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gencode);
		  }
|E '-' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s   %s=%s-%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			Optimize(optcode,$$.var,$1.var,"-",$3.var);
			sprintf($$.opt,"%s%s   %s\n",$1.opt,$3.opt,optcode);
			$$.gen=(char*)malloc(1000);
			GenCode(gencode,$$.var,$1.var,"-",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gencode);
		  }
|E '*' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s   %s=%s*%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			Optimize(optcode,$$.var,$1.var,"*",$3.var);
			sprintf($$.opt,"%s%s   %s\n",$1.opt,$3.opt,optcode);
			$$.gen=(char*)malloc(1000);
			GenCode(gencode,$$.var,$1.var,"*",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gencode);
		  }
|E '/' E {
			$$.code=(char*)malloc(1000);
			$$.var=(char*)malloc(10);
			sprintf($$.var,"t%d",t);t+=1;sprintf($$.code,"%s%s   %s=%s/%s\n",$1.code,$3.code,$$.var,$1.var,$3.var);
			$$.opt=(char*)malloc(1000);
			Optimize(optcode,$$.var,$1.var,"/",$3.var);
			sprintf($$.opt,"%s%s   %s\n",$1.opt,$3.opt,optcode);
			$$.gen=(char*)malloc(1000);
			GenCode(gencode,$$.var,$1.var,"/",$3.var);
			sprintf($$.gen,"%s%s%s",$1.gen,$3.gen,gencode);
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
|NUMBER {
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

C: E '<' E {
				$$.code=(char*)malloc(100);
				sprintf($$.code,"%s<%s",$1.var,$3.var);
		   }
|E '>' E {
			$$.code=(char*)malloc(100);
			sprintf($$.code,"%s>%s",$1.var,$3.var);
		 }
;
%%

void Optimize(char *out,char *lhs,char *v1,char *op,char *v2)
{	
	int flag=0;
	if(!strcmp(op,"+"))
	{
		if(!strcmp(v1,"0"))
			flag=1;
		if(!strcmp(v2,"0"))
			flag=4;
	}
	if(!strcmp(op,"*"))
	{
		if(!strcmp(v1,"1"))
			flag=1;
		if(!strcmp(v2,"1"))
			flag=4;
		if(!strcmp(v2,"2"))
			flag=5;
	}
	if(!strcmp(op,"/"))
	{
		if(!strcmp(v2,"1"))
			flag=4;
	}
	if(!strcmp(op,"-"))
	{
		if(!strcmp(v1,"0"))
			flag=3;
	}
	if(!strcmp(op,"-"))
	{
		if(!strcmp(v2,"0"))
			flag=4;
	}
	if(flag==0)
	{
		sprintf(out,"%s=%s%s%s",lhs,v1,op,v2);
	}
	else if(flag==1)
	{
		sprintf(out,"%s=%s",lhs,v2);
	}
	else if(flag==3)
	{
		sprintf(out,"%s=-%s",lhs,v2);
	}
	else if(flag==4)
	{
		sprintf(out,"%s=%s",lhs,v1);
	}
	else if(flag==5)
	{
		sprintf(out,"%s=%s+%s",lhs,v1,v2);
	}
}
void GenCode(char *out,char *lhs,char *v1,char *op,char *v2)
{	
	int flag=0;
	char var1[10],var2[10];
	if(v1[0]>='0' && v1[0]<='9')
	{
		var1[0]='#';
		var1[1]='\0';
		strcat(var1,v1);
	}
	else
	{
		strcpy(var1,v1);
	}
	if(v2[0]>='0' && v2[0]<='9')
	{
		var2[0]='#';
		var2[1]='\0';
		strcat(var2,v2);
	}
	else
	{
		strcpy(var2,v2);
	}
	if(!strcmp(op,"+"))
	{
		if(!strcmp(v1,"0"))
			flag=1;
		if(!strcmp(v2,"0"))
			flag=4;
	}
	if(!strcmp(op,"*"))
	{
		if(!strcmp(v1,"1"))
			flag=1;
		if(!strcmp(v2,"1"))
			flag=4;
		if(!strcmp(v2,"2"))
			flag=5;
	}
	if(!strcmp(op,"/"))
	{
		if(!strcmp(v2,"1"))
			flag=4;
	}
	if(!strcmp(op,"-"))
	{
		if(!strcmp(v1,"0"))
			flag=3;
	}
	if(!strcmp(op,"-"))
	{
		if(!strcmp(v2,"0"))
			flag=4;
	}
	if(flag==0)
	{
		if(!strcmp(op,"+"))
		{
			sprintf(out,"   MOV %s,R%d\n   ADD %s,R%d\n   MOV R%d,%s\n",var1,r,var2,r,r,lhs);
		}
		else if(!strcmp(op,"-"))
		{
			sprintf(out,"   MOV %s,R%d\n   SUB %s,R%d\n   MOV R%d,%s\n",var1,r,var2,r,r,lhs);
		}
		else if(!strcmp(op,"*"))
		{
			sprintf(out,"   MOV %s,R%d\n   MUL %s,R%d\n   MOV R%d,%s\n",var1,r,var2,r,r,lhs);
		}
		else if(!strcmp(op,"/"))
		{
			sprintf(out,"   MOV %s,R%d\n   DIV %s,R%d\n   MOV R%d,%s\n",var1,r,var2,r,r,lhs);
		}
		r+=1;
	}
	else if(flag==1)
	{
		sprintf(out,"   MOV %s,%s\n",var2,lhs);
	}
	else if(flag==3)
	{
		sprintf(out,"   MOV %s,R%d\n   NEG R%d\n   MOV R%d,%s\n",var2,r,r,r,lhs);
		r+=1;
	}
	else if(flag==4)
	{
		sprintf(out,"   MOV %s,%s\n",var1,lhs);
	}
	else if(flag==5)
	{
		sprintf(out,"   MOV %s,R%d\n   ADD %s,R%d\n   MOV R%d,%s\n",var1,r,var2,r,r,lhs);
		r+=1;
	}
}

void yyerror(char *str)
{ 
   fprintf(stderr,"%s\n",str);
} 


void main() 
{ 
   printf("Lexical Analyser :\n\n");
   yyparse(); 
} 