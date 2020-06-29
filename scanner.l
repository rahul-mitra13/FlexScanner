/*
 * scanner.l - a lexical analyzer for P-
 *
 * Rahul Mitra
 *
 * Date:28th September, 2019
 * Assignment 2, CPSC 316
 *
 */

%{


#include <stdio.h>
#include "msg.h"
#define N 10000
void modify(char a[], char b[]);

int cLine = 1;
extern int cErrors;
extern char *infile;
int store;/*To store the line number for a multi line string*/

%}

DIGIT           [0-9]
ID              ([a-zA-Z]|"_")([0-9]|[a-zA-Z]|"_")*
%x              COMMENT STRING
%%


(?i:array)|(?i:begin)|(?i:bool)|(?i:else)|(?i:elif)|(?i:end)|(?i:false)|(?i:for)|(?i:float)|(?i:function)|(?i:if)|(?i:in)|(?i:int)|(?i:of)|(?i:procedure)|(?i:program)|(?i:read)|(?i:record)|(?i:return)|(?i:then)|(?i:true)|(?i:while)|(?i:write)   {
                                                fprintf(stderr, message[mnKeywordFound], infile, cLine, yytext);/*Keywords*/
                                            }
{DIGIT}+            {
                        fprintf(stderr, message[mnInteger], infile, cLine, yytext);/*Integers*/
                    }
{DIGIT}*"."{DIGIT}+ {
                      fprintf(stderr, message[mnFloat],infile,cLine, yytext);/*Floats*/
                    }
{ID}                {
                      fprintf(stderr, message[mnIdentifier],infile,cLine, yytext);
                    }
"&"|"="|"!"|":"|","|"."|">"|"<"|"["|"]"|"("|")"|"+"|"-"|"*"|"/"|";" {
                                                                        fprintf(stderr, message[mnSimpleOperator],infile,cLine, yytext);/*Simple Operators*/
                                                                    }
"&&"|"||"|">="|"<="|"=="|"!="|".." {
                                     fprintf(stderr, message[mnCompoundOperator],infile,cLine, yytext);/*Compound Operators*/
                                   }
["]                                {yymore(); BEGIN(STRING); store = cLine;}/*Strings*/
<STRING>(\\.|[^"\\^\n])*              {yymore();}  /*Collect all escape characters and anything that's not a quote*/
<STRING>(\n)                       {yymore(); cLine++;}
<STRING>["]                {    
                                BEGIN(INITIAL);
                                char copy[N];
                                modify(yytext,copy);
                                fprintf(stderr, message[mnLegalString],infile,store,copy);
                           }
<STRING><<EOF>>         {fprintf(stderr, message[mnIllegalString],infile,cLine - 1,yytext); yyterminate();}/*Terminate if you see an unclosed string*/
 
 
"\n"                            cLine++;/*Increment new line character*/
[\t| |\f]+                      /*Ignore tabs and formfeeds*/
                                                                                            
  .                       {
                                fprintf(stderr, message[mnUnknownChar], infile, cLine, yytext[0]);/*Unknown characters*/
                                cErrors++;
                          }
"/*"                  {BEGIN(COMMENT);}/*Comments*/
<COMMENT>"/*"         {fprintf(stderr,message[mnIllegalComment],infile, cLine,""); yyterminate();} /*Terminate if you find a nested comment*/
<COMMENT>[^/*\n]*     
<COMMENT>["/"]*
<COMMENT>\n           {cLine++;} /*Increment cLine if you see a new line character*/
<COMMENT>"*"+"/"      {BEGIN(INITIAL);}
<COMMENT><<EOF>>      {fprintf(stderr,message[mnIllegalComment],infile, cLine - 1,""); yyterminate();}
 
                                        
%%

/* User routines go here */
/*This is a function to handle escape characters in a string*
*Parameters: char array a[] which is to be modified
*Parameters: char array b[] which stores the modified string
*Return type: void
*/
void modify(char a[], char b[]){
    int i;
    i = 0;
    int k;
    k = 0;
    while ( a[i] != '\0'){
        if ( a[i] == '\\' && a[i+1] == '\\'){/*If theres is an escape character for a backslash*/
                b[k++] = '\\';
                i = i + 2;
         }
         else if ( a[i] == '\\' && a[i + 1] == '"'){/*If there is an escape character for a quote*/
                b[k++] = '"';
                i = i + 2;
         }
         else{
                b[k++] = a[i];
                i++;
        }
   }
   b[k] = '\0';
}

