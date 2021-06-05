#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void LReliminator(char prod[],char local[],char temp[]);
void main()
{
    char stmt[50];
    FILE *fp = fopen("test_file.c", "r");
    if(fp == NULL)
    {
        perror("Unable to open file!");
        exit(1);
    }
    char prod[500]="";
    char temp[200]="";
    while(fgets(stmt, sizeof(stmt), fp) != NULL) 
    {
        LReliminator(stmt,temp,prod);
        strcpy(stmt,"\0");
    }
    printf("%s",prod);     
    fclose(fp);
}
void LReliminator(char prod[],char local[],char temp[])
{
    
    int i,j=0,k=0,c=0,flag=0,d=0,e=0;
    if(prod[strlen(prod)-1]=='\n')
    {
        prod[strlen(prod)-1]='\0';
    }
    char * token = strtok(prod,"->"),lhs[20]="",rhs[20]="";
    char tokens[20][20],alpha[20][20],beta[20][20],lr[20][20];
          
    while( token != NULL ) 
    {
        strcpy(tokens[c++],token);
        token = strtok(NULL, "->");
    }
    //printf("%s\t%s\n",tokens[0],tokens[1]);
    strcpy(lhs,tokens[0]);
    strcpy(rhs,tokens[1]);
    char *tk=strtok(rhs,"|");
    c=0;
    while( tk!= NULL ) 
    {
        strcpy(tokens[c++],tk);
        tk= strtok(NULL, "|");
    }
    for(i=0;i<c;i++)
    {
        for(j=0;j<strlen(lhs);j++)
        {
            if(lhs[j]==tokens[i][j])
                continue;
            else
            {
                flag=1;
                break;
            }
        }
        if(flag==1)
            strcpy(beta[d++],tokens[i]);
        else
            strcpy(lr[e++],tokens[i]);
    }
    if(e==0)
    {
        sprintf(local,"%s->",lhs);
        strcat(temp,local);
        for(i=0;i<c-1;i++)
        {
            sprintf(local,"%s|",tokens[i]);
            strcat(temp,local);
        }
        sprintf(local,"%s\n",tokens[c-1]);
        strcat(temp,local);
        return;
    }
    if(d==0)
    {
        strcpy(beta[d++],"(epsilon)");
    }
    sprintf(local,"%s->",lhs);
    strcat(temp,local);
    for(i=0;i<d;i++)
    {
        sprintf(local,"%s%s'",beta[i],lhs);
        strcat(temp,local);
    }
    sprintf(local,"\n");
    strcat(temp,local);
    sprintf(local,"%s'->(epsilon)|",lhs);
    strcat(temp,local);
    for(i=0;i<e;i++)
    {
        for(j=strlen(lhs);j<strlen(lr[i]);j++)
            alpha[i][k++]=lr[i][j];
        alpha[i][k]='\0';
        k=0;
        if(i!=e-1)
        {
            sprintf(local,"%s%s'|",alpha[i],lhs);
            strcat(temp,local);
        }
        else
        {
            sprintf(local,"%s%s'\n",alpha[i],lhs);  
            strcat(temp,local);    
        }

    }
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