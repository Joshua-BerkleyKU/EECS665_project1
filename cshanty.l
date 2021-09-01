%{
#include <string>
#include <limits.h>

/* Get our custom yyFlexScanner subclass */
#include "scanner.hpp"
#include "tokens.hpp"
#undef  YY_DECL
#define YY_DECL int cshanty::Scanner::yylex( cshanty::Parser::semantic_type * const lval )

/* define yyterminate as this instead of NULL */
#define yyterminate() return( TokenKind::END )

/* Exclude unistd.h for Visual Studio compatability. */
#define YY_NO_UNISTD_H

/* typedef to make the reference to token kinds shorter */
using TokenKind = cshanty::Parser::token;

%}

%option debug
%option nodefault
%option yyclass="cshanty::Scanner"
%option noyywrap
%option c++

DIGIT [0-9]

%%
%{          /** Code executed at the beginning of yylex **/
            yylval = lval;
%}

"+"|plus	{
		// Keep track of the "kind" of token we matched. In this case,
		// it's a PLUS (aka the plus symbol). The full list of token
		// kinds is declared around line 197 of grammar.hh. The testing
		// functionScanner::outputTokens also indicates what each token
		// represents (declared in scanner.cpp line 9)
		int tokenKind = TokenKind::PLUS;

		//Instatiate a token. There are 4 classes of tokens defined based on 
		// - a literal string (StringLitToken)
		// - a literal integer (IntLitToken)
		// - an identifier (IDToken)
		// - a base Token (any other type)
		// The token object is a handy place to keep information about the
		// token (i.e. token metadata) such as the line and column on which
		// the token character started (which can be used later in debug 
		// messages, etc). 
		Token * token = new Token(lineNum, colNum, tokenKind);

		//Assign the token to a instance variable of the scanner.
		// (When Flex processes a .l file in C++ mode, it creates 
		// a class called Scanner, which is a subclass of yyFlexScanner)
		// By assigning a value to this field, we put the token
		// metadata in a place where scanner's client program can find it.
		this->yylval->lexeme = token;

		//Since we consumed 1 character, increase the column number by 1
		colNum += yyleng;

		//Let the scanner's client program know that a PLUS token
		// has been matched
		return tokenKind;
		}

"-"|minus  {
		//Essentially the same thing as PLUS, but without the verbose
		// comments so it doesn't look so scary.
		int tokenKind = TokenKind::MINUS;
		this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
		colNum += yyleng;
		return tokenKind;
		}

{DIGIT}+	{
		//TODO: The following computation of the integer
		// value does not check for overflow. It should do so.
		int intVal = atoi(yytext);
		std::string overflowCheck = std::to_string(intVal);

		if (yytext != overflowCheck) {
			errIntOverflow(lineNum,colNum);
			colNum += yyleng;
		} else {
			//Note that the IntLitToken does not take a TokenKind argument
			// since it's implicitly known that the token represents an
			// INTLITERAL		
			yylval->lexeme = new IntLitToken(lineNum, colNum, intVal);

			//TODO: update the colNum count according to the number of
			// characters consumed. 
			colNum += yyleng;

			//As before, alert the client program that an INTLITERAL 
			// token was matched
			return TokenKind::INTLITERAL;
		}

		}

\n		{
			//Update the line number, reset the columnNumber
			lineNum++;
			colNum = 1;
		}

[ \t]+	{
			colNum += yyleng;
		}

"/"+(.)* 	{

}

int 	{
			int tokenKind = TokenKind::INT;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

bool  	{
			int tokenKind = TokenKind::BOOL;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

string  {
			int tokenKind = TokenKind::STRING;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

void   	{
			int tokenKind = TokenKind::VOID;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

aye|true	{
			int tokenKind = TokenKind::TRUE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

gets|"="    {
			int tokenKind = TokenKind::ASSIGN;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

if      {
			int tokenKind = TokenKind::IF;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

else    {
			int tokenKind = TokenKind::ELSE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

while 	{
			int tokenKind = TokenKind::WHILE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

return|[we'll take our leave and go]	{
										int tokenKind = TokenKind::RETURN;
										this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
										colNum += yyleng;
										return tokenKind;
									}

nay|false 	{
			int tokenKind = TokenKind::FALSE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

ahoy|"{" 	{
			int tokenKind = TokenKind::OPEN;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

times|"*"	{
			int tokenKind = TokenKind::TIMES;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

receive {
			int tokenKind = TokenKind::RECEIVE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

record 	{
			int tokenKind = TokenKind::RECORD;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

report  {
			int tokenKind = TokenKind::REPORT;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

divide|"/"	{
			int tokenKind = TokenKind::DIVIDE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

or|"||"		{
			int tokenKind = TokenKind::OR;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

and|"&&"		{
			int tokenKind = TokenKind::AND;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

[shove off]|"}" 	{
				int tokenKind = TokenKind::CLOSE;
				this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
				colNum += yyleng;
				return tokenKind;
			}

[heave and go]|[roll and go]|";" 	{
								int tokenKind = TokenKind::SEMICOL;
								this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
								colNum += yyleng;
								return tokenKind;
							}

","		{
			int tokenKind = TokenKind::COMMA;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

"--"    {
			int tokenKind = TokenKind::DEC;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

"++"	{
			int tokenKind = TokenKind::INC;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

"!"		{
			int tokenKind = TokenKind::NOT;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

"!="	{
			int tokenKind = TokenKind::NOTEQUALS;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

"=="	{
			int tokenKind = TokenKind::EQUALS;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

"<"		{
			int tokenKind = TokenKind::LESS;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

"<="	{
			int tokenKind = TokenKind::LESSEQ;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

">"		{
			int tokenKind = TokenKind::GREATER;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

">="	{
			int tokenKind = TokenKind::GREATEREQ;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum += yyleng;
			return tokenKind;
		}

"["		{
			int tokenKind = TokenKind::LBRACE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

"]"		{
			int tokenKind = TokenKind::RBRACE;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

"("		{
			int tokenKind = TokenKind::LPAREN;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}

")"		{
			int tokenKind = TokenKind::RPAREN;
			this->yylval->lexeme = new Token(lineNum, colNum, tokenKind);
			colNum++;
			return tokenKind;
		}


[//].* {
				// comment
			}

[\"].*[^\"]	{
						errStrUnterm(lineNum, colNum);
						colNum += yyleng;
						// keeping this in case I need it: [^\"\n\\]|[\\([^\n]|[\n])]
					}


\"\\([A-Z]|[a-z]|[0-9]|[ ])\" {
									errStrEsc(lineNum, colNum);
									colNum += yyleng;
}

\"([^\\\"]|\\.)*\"	{	
						std::string StringVal = yytext;
						this->yylval->lexeme = new StrToken(lineNum, colNum, StringVal);
						colNum += yyleng;
						return TokenKind::STRLITERAL;
						
					}

([A-Z]|[a-z]|_)+([A-Z]|[a-z]|[0-9])*	{
										
											std::string idVal = yytext;
											this->yylval->lexeme = new IDToken(lineNum, colNum, idVal);
											colNum += yyleng;
											return TokenKind::ID;
										}


.   {
		//TODO: Add the rest of the rules above this point so that legal characters
		// are properly accounted for.
		errIllegal(lineNum,colNum,yytext);
		colNum += yyleng;
    }
%%
