#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void LReliminator(char prod[]);
void main()
{
	char stmt[50];
	FILE *fp = fopen("test_file.c", "r");
    if(fp == NULL)
   	{
    	perror("Unable to open file!");
    	exit(1);
	}
 
	while(fgets(stmt, sizeof(stmt), fp) != NULL) 
    {
	    LReliminator(stmt);
	    strcpy(stmt,"\0");
    }
 
	fclose(fp);
}
void LReliminator(char prod[])
{
	int i,j=0,c=0;
	char * token = strtok(prod,"->"),lhs[20]="",rhs[20]="";
	char tokens[20][20],alpha[20];
   	while( token != NULL ) 
   	{
      strcpy(tokens[c++],token);
      token = strtok(NULL, "->");
   	}
   	//printf("%s\n%s\n",tokens[0],tokens[1]);
   	strcpy(lhs,tokens[0]);
   	strcpy(rhs,tokens[1]);
   	for(i=0;i<strlen(lhs);i++)
   	{
   		if(lhs[i]==rhs[i])
   		{
   			continue;
   		}
   		else 
   		{
   			j=1;
   			break;
   		}
   	}

   	if(j==1)
   	{
   		printf("%s->%s\n",lhs,rhs);
   		return;
   	}

   	for(j=0;rhs[i]!='|';i++,j++)
   	{
   		alpha[j]=rhs[i];
   	}
   	alpha[i]='\0';
   	j=-1;

	for(i=0;i<strlen(rhs);i++)
	{
		if(rhs[i]=='|')
		{
			j=i;
			break;
		}
	} 
	if(j==-1)
	{
		printf("LR cant be eliminated\n");
		return;
	}  

	c=0;
	char *tok=strtok(rhs,"|");
	
	while( tok != NULL ) 
   	{
      strcpy(tokens[c++],tok);
      tok = strtok(NULL,"|");
    }
    if(tokens[c-1][strlen(tokens[c-1])-1]=='\n')
    {
    	tokens[c-1][strlen(tokens[c-1])-1]='\0';
    }
   	printf("%s->",lhs);
	i=1;   
   	while(i<c)
   	{
   		if(i!=c-1)
   		printf("%s%s'|",tokens[i],lhs);
   		else
   		printf("%s%s'",tokens[i],lhs);
   		i++;
   	}
   	printf("\n%s'->(epsilon)|%s%s'\n",lhs,alpha,lhs);
   	
}
	
/*
Input File:
E->E+T|T
T->T*F|F
F->i

Output:
E->TE'
E'->(epsilon)|+TE'
T->FT'
T'->(epsilon)|*FT'
F->i

*/