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
#include "zoomjoystrong.tab.h"

%}

%%

end             { return END; }
\;              { return END_STATEMENT; }
point           { return POINT; }
line            { return LINE; }
circle          { return CIRCLE; }
rectangle       { return RECTANGLE; }
set_color       { return SET_COLOR; }
[0-9]+          { yylval.iVal = atoi(yytext);
                  if (yylval.iVal > -1 && yylval.iVal < 256) {
                      return VALID_COLOR;
                  }
                  else {
                      return INT;
                  }                 
                }
[A-Za-z]+       { yylval.sVal = yytext;
                  return NOT_VALID; 
                }   
[0-9]*\.[0-9]+  { yylval.fVal = atof(yytext); 
                  return FLOAT; }
" "|\n|\t|.     ;

%%
