#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void print(char *input)
{
	if(input[0]=='\n'||input[0]=='\0')
	{	
		printf("%c",input[0]);
		return;
	}
	int flag=0;
	if(input[3]=='+')
	{
		if(input[2]=='0')
			flag=1;
		if(input[4]=='0')
			flag=4;
	}
	if(input[3]=='*')
	{
		if(input[2]=='1')
			flag=1;
		if(input[4]=='1')
			flag=4;
		if(input[4]=='2')
			flag=5;
	}
	if(input[3]=='/')
	{
		if(input[4]=='1')
			flag=4;
	}
	if(input[2]=='p'&&input[3]=='o'&&input[4]=='w')
	{
		if(input[8]=='2')
			flag=2;
	}
	if(input[3]=='-')
	{
		if(input[2]=='0')
			flag=3;
	}
	if(input[3]=='-')
	{
		if(input[4]=='0')
			flag=4;
	}
	if(flag==0)
	{
		printf("%s",input);
	}
	else if(flag==1)
	{
		printf("%c=%c\n",input[0],input[4]);
	}
	else if(flag==2)
	{
		printf("%c=%c*%c\n",input[0],input[6],input[6]);
	}
	else if(flag==3)
	{
		printf("%c=-%c\n",input[0],input[4]);
	}
	else if(flag==4)
	{
		printf("%c=%c\n",input[0],input[2]);
	}
	else if(flag==5)
	{
		printf("%c=%c+%c\n",input[0],input[2],input[2]);
	}
}
void main(int argc,char *argv[])
{	
	char input[1000];
	FILE *fp = fopen("input.txt", "r");
    if(fp == NULL)
   	{
    	perror("Unable to open file!");
    	exit(1);
	}
 	int i=0;
	while(fgets(input, sizeof(input), fp) != NULL) 
    {
	    print(input);
	    strcpy(input,"\0");
    }
    printf("\n");
	fclose(fp);
}

