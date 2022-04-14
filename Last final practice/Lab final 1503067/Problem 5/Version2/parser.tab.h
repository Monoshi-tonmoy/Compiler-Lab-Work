/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CHAR = 258,
    INT = 259,
    FLOAT = 260,
    DOUBLE = 261,
    IF = 262,
    ELSE = 263,
    WHILE = 264,
    FOR = 265,
    CONTINUE = 266,
    BREAK = 267,
    VOID = 268,
    RETURN = 269,
    PRINT = 270,
    DO = 271,
    DHORI = 272,
    RO = 273,
    LO = 274,
    SURU = 275,
    SESH = 276,
    ADDOP = 277,
    MULOP = 278,
    DIVOP = 279,
    INCR = 280,
    OROP = 281,
    ANDOP = 282,
    NOTOP = 283,
    EQUOP = 284,
    LT = 285,
    GT = 286,
    SUB = 287,
    GTE = 288,
    LTE = 289,
    PURNOSONGKHA = 290,
    LPAREN = 291,
    RPAREN = 292,
    LBRACK = 293,
    RBRACK = 294,
    LBRACE = 295,
    RBRACE = 296,
    SEMI = 297,
    DOT = 298,
    COMMA = 299,
    ASSIGN = 300,
    REFER = 301,
    APOSTOPH = 302,
    ID = 303,
    ICONST = 304,
    FCONST = 305,
    CCONST = 306,
    STRING = 307,
    RELOP = 308
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "parser.y" /* yacc.c:1909  */

    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* id;
 

#line 117 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
