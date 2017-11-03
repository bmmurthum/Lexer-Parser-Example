%{

/*
 * Author: Brendon Murthum
 * Date: November 1, 2017
 * Class: CIS 343 - Structure of Programming Languages
 * Professor: Ira Woodring
 *
 * This code is a *parser* that runs in tandem with a lexer to take input
 * language, validate words and sentences, to then run the appropriate
 * commands as given.
 *
 * NOTE: The lexer reads floats to pass to this parser, but the drawing
 *       program backing this does NOT take floats to its commands. This
 *       is handled within this parser.
 * NOTE #2: The lexer determines if a number is within range to be valid
 *          within the set_color command by sending INTs within valid range
 *          by the token VALID_COLOR rather than INT.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "zoomjoystrong.h"

int yylex();

/* This is called when "error" is popped as a token. */
/* The old error-handling simply prints 'syntax error' */
void yyerror(char* s) {
    /* fprintf(stderr, "%s\n",s); */
}

/* This is called when input is exhausted. */
int yywrap() {
    return (1);
}

%}

%union {
    int iVal;
    float fVal;
    char* sVal;
}

/* Declaring tokens from the lexer */
%token INT
%token FLOAT
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token VALID_COLOR
%token NOT_VALID
%token SPACE

/* Setting types for certain tokens that handle variables */
%type<fVal> FLOAT
%type<iVal> value color INT VALID_COLOR
%type<sVal> NOT_VALID

%%

/* Setting grammar rules. */
program:         statement_list END;
statement_list:  statement 
              |  statement statement_list
              ;
statement:       command
         |       error command 
                    { 
                        yyerrok; 
                        printf("  WARNING: Command dropped!\n\n"); 
                    }
         ;
command:         LINE value value value value END_STATEMENT
                   {    
                        /* If line is within bounds */
                        if($2 >= 0 && $2 <= WIDTH &&
                           $3 >= 0 && $3 <= HEIGHT &&
                           $4 >= 0 && $4 <= WIDTH &&
                           $5 >= 0 && $5 <= HEIGHT) {
                            /* Draw the line! */
                            line($2, $3, $4, $5);
                        }
                        else {
                            printf("  ERROR: Display points " \
                                          "out of bounds!\n");
                            printf("  WARNING: Command dropped!\n\n"); 
                        }                        
                   }
         |       POINT value value END_STATEMENT
                   {
                        /* If point is within bounds */
                        if($2 >= 0 && $2 <= WIDTH &&
                           $3 >= 0 && $3 <= HEIGHT ) {
                            /* Draw the point! */
                            point($2,$3); 
                        }
                        else {
                            printf("  ERROR: Display points " \
                                          "out of bounds!\n");
                            printf("  COMMAND: point %d %d"\
                                       "...\n", $2, $3);
                            printf("  WARNING: Command dropped!\n\n"); 
                        }
                   }
         |       CIRCLE value value value END_STATEMENT
                   {    
                        /* If circle is within bounds */
                        if( ($2 - $4) >= 0 && ($2 + $4) <= WIDTH &&
                            ($3 - $4) >= 0 && ($3 + $4) <= HEIGHT ) {
                            /* Draw the circle! */
                            circle($2,$3,$4); 
                        }
                        else {
                            printf("  ERROR: Circle is " \
                                          "out of bounds!\n");
                            printf("  WARNING: Command dropped!\n\n"); 
                        }
                   }
         |       RECTANGLE value value value value END_STATEMENT
                   { 
                        /* If rectangle is within bounds */
                        if($2 <= WIDTH && $2 >= 0 &&
                           $3 <= HEIGHT && $3 >= 0 &&
                           (($2 + $4) <= WIDTH) &&
                           (($3 + $5) <= HEIGHT) ) {
                            /* Draw the rectangle */
                            rectangle($2,$3,$4,$5);
                        }
                        else {
                            printf("  ERROR: Rectangle out of bound!\n");
                            printf("  COMMAND: rectangle %d %d %d %d "\
                                       "...\n", $2, $3, $4, $5);
                            printf("  WARNING: Command dropped!\n\n"); 
                        }
                   }
         |       SET_COLOR color color color END_STATEMENT
                   { 
                        /* Set the color */
                        if ($2 < 256 && $2 > -1 &&
                            $3 < 256 && $3 > -1 &&
                            $4 < 256 && $3 > -1) {
                            set_color($2,$3,$4);
                        } 
                        else {
                            printf("  ERROR: Invalid colors!\n");
                            printf("  WARNING: Command dropped!\n\n"); 
                        }      
                   }
         |       NOT_VALID 
                   {
                        printf("  ERROR: Invalid command!\n");
                        printf("  COMMAND: %s!\n", $1);
                   }
         ;
value:          INT     { $$ = $1; }
         |      FLOAT   { $$ = $1; }
         |      VALID_COLOR  { $$ = $1; }
         ;
color:          VALID_COLOR   { $$ = $1; };
         
%%

/* MAIN */
int main(int argc, char** argv) {

    /* Welcome message. */
    printf("\nThe following is an error log from taking commands:\n\n");

    /* Start the drawing window. */    
    setup();
    
    /* Parse the language from the input. */
    return(yyparse());

    /* Finish the drawing program. */
    finish();

}

