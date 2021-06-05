#include<stdio.h>
#include<string.h>
#include<stdlib.h>
char input[100];
int length=0,flag=0,indt=0;
void E();
void T();
void Edash();
void Tdash();
void F();
void indent();

void main()
{
    int l;
    printf("Enter the Input String:");
    scanf("%s",input);
    l=strlen(input);
    input[l]='$';
    input[l+1]='\0';

    E();
    if(input[length]=='$')
        printf("\nThe given string is accepted\n");
    else
    {
        printf("Mismatch at position %d:%c\n",length,input[length]);
        printf("String is not accepted\n");
    }
}
void E()
{   indent();
    indt+=1;
    printf(" called E()\n");
    T();
    Edash();
    indt-=1;
}
void Edash()
{
    indent();
    indt+=1;
    printf(" called E'() ");
    if(input[length]=='+'||input[length]=='-')
    {
        if(input[length]=='+')
            printf("Matched +\n");

        else
            printf("Matched -\n");
        length++;
        T();
        Edash();
    }
    else
    printf("\n");
    indt-=1;
}
void T()
{
    indent();
    indt+=1;
    printf(" called T()\n");
    F();
    Tdash();
    indt-=1;
}
void Tdash()
{
    indent();
    indt+=1;
    printf(" called T'() ");
    if(input[length]=='*'||input[length]=='/')
    {
        if(input[length]=='*')
            printf("Matched *\n");

        else
            printf("Matched /\n");
        length++;
        F();
        Tdash();
    }
    else
        printf("\n");
    indt-=1;
}
void F()
{
    indent();
    indt+=1;
    printf(" called F() ");
    indt-=1;
    if(input[length]=='i' && input[length+1]=='d')
    {
        printf("Matched id\n");
        length+=2;
    }
    else if(input[length]=='(')
    {
        printf("Matched (\n");
        length++;
        E();
        if(input[length]==')')
        {
            indt+=1;
            indent();
            indt-=1;
            printf("Matched )\n");
            length++;
        }
        else
        {
            printf("Mismatch at position %d:%c\n",length,input[length]);
            printf("String is not accepted\n");
            exit(1);
        }
    }
    else
    {
        printf("Mismatch at position %d:%c\n",length,input[length]);
        printf("String is not accepted\n");
        exit(1);
    }
}
void indent()
{
    int i;
    for(i=0;i<indt;i++)
    {
        printf("\t");
    }
}
    	
/*
Input Grammar:
E->E+T|T
T->T*F|F
F->id

LR elimination:
E->TE'
E'->(epsilon)|+TE'
T->FT'
T'->(epsilon)|*FT'
F->id

Input Grammar:
E->E+T|E-T|T
T->T*F|T/F|F
F->(E)|id

LR elimination:
E->TE'
E'->(epsilon)|+TE'|-TE'
T->FT'
T'->(epsilon)|*FT'|/FT'
F->(E)|id

*/

/*

sudhan@sudhan-VirtualBox:~/Desktop/SEM6/CD/RDparser$ gcc -o k RDparser.c
sudhan@sudhan-VirtualBox:~/Desktop/SEM6/CD/RDparser$ ./k
Enter the Input String:(id+id)*id/id
 called E()
 called T()
 called F()
 called E()
 called T()
 called F()
 called T'()
 called E'()
 called T()
 called F()
 called T'()
 called E'()
 called T'()
 called F()
 called T'()
 called F()
 called T'()
 called E'()
The given string is accepted

sudhan@sudhan-VirtualBox:~/Desktop/SEM6/CD/RDparser$ ./k
Enter the Input String:id*+
 called E()
 called T()
 called F()
 called T'()
 called F()
String is not accepted


*/