# Lexer-Parser Example

This project is an exercise showing how lexxers and compilers work in tandem to validate and run external commands. This project is tied to an assignment of Prof. Ira Woodring. We used [GNU Bison 3.0.4](https://www.gnu.org/software/bison/) to handle the [YACC](http://dinosaur.compilertools.net/yacc/) files. We used [Flex 2.5.37](https://github.com/westes/flex) to handle the lex-files.

## Project Specifications

**Flex File**

The Flex file defines the following tokens:

- END. This statement ends a program.
- END_STATEMENT. All commands should end with a semicolon.
- POINT. When we match the command to plot a point.
- LINE. When we match the command to draw a line.
- CIRCLE. When we match the command to draw a circle.
- RECTANGLE. When we match the command to draw a rectangle.
- SET_COLOR. Matches the command to change colors.
- INT. Matches an integer value.
- FLOAT. Matches a floating-point value.
- A way to match tabs, spaces, or newlines, and to ignore them.
- A way to match anything not listed above, and to tell the user they messed up.

**Bison File**

The Bison file will define the grammar of the language. We want to support:

- A statement list of one or (arbitrarily) more statements followed by the END token.
- Valid statements followed by the END_STATEMENT token.
- A line command of the syntax line x y u v that will plot a line from x,y to u,v.
- A point command of the syntax point x y that plots a single point at x,y.
- A circle command with the syntax circle x y r that plots a circle of radius r around the center point at x, y.
- A rectangle command with the syntax rectangle x y w h that draw a rectangle of height h and width w beginning at the top left edge x,y.
- A set color statement with syntax set_color r g b that changes the current drawing color to the r,g,b tuple.

## Compiling

Bison creates the `zoomjoystrong.tab.h` and `zoomjoystrong.tab.c` files when we run the command `bison -d zoomjoystrong.y`. We include the `zoomjoystrong.tab.h` file in our zoomjoystrong.lex file so that the lexer will return the correct tokens to the parser.

Flex will create the `lex.yy.c` lexer code when we run the command `flex zoomjoystrong.lex`.

We then compile `zoomjoystrong.c`, `lex.yy.c`, and `zoomjoystrong.tab.c` into an executable called zjs.

**Quick Steps**

1. Prepare the YACC-file with Bison.

```
bison -d zoomjoystrong.y
```

2. Use Flex to generate the lexer code.

```
flex zoomjoystrong.lex
```

3. Compile them together with GCC.

```
gcc -o zjs zoomjoystrong.c lex.yy.c zoomjoystrong.tab.c -lSDL2 -lm -std=c99
```

4. Test a sample file.

```
./zjs < sample.zjs
```

## Notes

**Compilation Errors/Warnings**

Running the YACC-file by Bison and the lex-file by Flex threw no errors. Upon compilation with GCC there was one warning that I did not handle due to its being caused by Bison itself. This could be an issue of an #include in a incorrect spot.

```C
implicit declaration of function ‘fileno’ [-Wimplicit-function-declaration]
         b->yy_is_interactive = file ? (isatty( fileno(file) ) > 0) : 0;
```

**Error Handling**

The program handles several potential errors from the user. As it is a simple parser that handles only a handful of commands, the errors managed are:
1. Mistypings of commands
2. Wrong number of arguments in commands
3. Incorrect values for `set_color` 
4. Validating that the generated shapes and lines are within bounds 
5. Managing floating-points inputs to the application's int-required arguments

Errors write to the terminal telling of which command or argument raised the issue and warn that the command at issue was dropped so that the program could continue on without breaking.

**Style Guide**

During development, I put emphasis on following the [GVSU-Coding-Style-Guide](http://www.cis.gvsu.edu/java-coding-style-guide/) as relevant. The standard formatting of lex-files and YACC-files put some constraint on following the guide strictly. 

