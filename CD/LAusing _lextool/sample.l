%{
	#include<stdio.h>

%}

zero [0]
number [-]?[0-9]+

%%
{zero} {return 0;}
{number} {return (atoi(yytext)>0)?1:-1;}	

%%

int main()
{
	int i=0,c;
	while(c=yylex())
	{
		if(c==1)
		i++;
		else if(c==0)
		break;
	}
	printf("Count=%d",i);
}
int yywrap(void){}