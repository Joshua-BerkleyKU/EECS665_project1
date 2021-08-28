#include "tokens.hpp" // Get the class declarations
#include "grammar.hh" // Get the TokenKind definitions

namespace cshanty{

using TokenKind = cshanty::Parser::token;
using Lexeme = cshanty::Parser::semantic_type;

static std::string tokenKindString(int tokKind){
	switch(tokKind){
		case TokenKind::END: return "EOF";
		case TokenKind::AND: return "AND";
		case TokenKind::ASSIGN: return "ASSIGN";
		case TokenKind::BOOL: return "BOOL";
		case TokenKind::CLOSE: return "CLOSE";
		case TokenKind::COMMA: return "COMMA";
		case TokenKind::DEC: return "DEC";
		case TokenKind::DIVIDE: return "DIVIDE";
		case TokenKind::ELSE: return "ELSE";
		case TokenKind::EQUALS: return "EQUALS";
		case TokenKind::FALSE: return "FALSE";
		case TokenKind::GREATER: return "GREATER";
		case TokenKind::GREATEREQ: return "GREATEREQ";
		case TokenKind::ID: return "ID";
		case TokenKind::IF: return "IF";
		case TokenKind::INC: return "INC";
		case TokenKind::INT: return "INT";
		case TokenKind::INTLITERAL: return "INTLITERAL";
		case TokenKind::LBRACE: return "LBRACE";
		case TokenKind::LESS: return "LESS";
		case TokenKind::LESSEQ: return "LESSEQ";
		case TokenKind::LPAREN: return "LPAREN";
		case TokenKind::MINUS: return "MINUS";
		case TokenKind::NOT: return "NOT";
		case TokenKind::NOTEQUALS: return "NOTEQUALS";
		case TokenKind::OPEN: return "OPEN";
		case TokenKind::OR: return "OR";
		case TokenKind::PLUS: return "PLUS";
		case TokenKind::RBRACE: return "RBRACE";
		case TokenKind::RECEIVE: return "RECEIVE";
		case TokenKind::REPORT: return "REPORT";
		case TokenKind::RETURN: return "RETURN";
		case TokenKind::RPAREN: return "RPAREN";
		case TokenKind::SEMICOL: return "SEMICOL";
		case TokenKind::STRING: return "STRING";
		case TokenKind::STRLITERAL: return "STRINGLITERAL";
		case TokenKind::TIMES: return "TIMES";
		case TokenKind::TRUE: return "TRUE";
		case TokenKind::VOID: return "VOID";
		case TokenKind::WHILE: return "WHILE";
		default:	
			return "OTHER";
	}
	
}

Token::Token(size_t lineIn, size_t columnIn, int kindIn)
  : myLine(lineIn), myCol(columnIn), myKind(kindIn){
}

std::string Token::toString(){
	return tokenKindString(kind())
	+ " [" + std::to_string(line()) 
	+ "," + std::to_string(col()) + "]";
}

size_t Token::line() const { 
	return this->myLine; 
}

size_t Token::col() const { 
	return this->myCol; 
}

int Token::kind() const { 
	return this->myKind; 
}

IDToken::IDToken(size_t lIn, size_t cIn, std::string vIn)
  : Token(lIn, cIn, TokenKind::ID), myValue(vIn){ 
}

std::string IDToken::toString(){
	return tokenKindString(kind()) + ":"
	+ this->myValue
	+ " [" + std::to_string(line()) 
	+ "," + std::to_string(col()) + "]";
}

const std::string IDToken::value() const { 
	return this->myValue; 
}

StrToken::StrToken(size_t lIn, size_t cIn, std::string sIn)
  : Token(lIn, cIn, TokenKind::STRLITERAL), myStr(sIn){
}

std::string StrToken::toString(){
	return tokenKindString(kind()) + ":"
	+ this->myStr
	+ " [" + std::to_string(line()) 
	+ "," + std::to_string(col()) + "]";
}

const std::string StrToken::str() const {
	return this->myStr;
}

IntLitToken::IntLitToken(size_t lIn, size_t cIn, int numIn)
  : Token(lIn, cIn, TokenKind::INTLITERAL), myNum(numIn){}

std::string IntLitToken::toString(){
	return tokenKindString(kind()) + ":"
	+ std::to_string(this->myNum)
	+ " [" + std::to_string(line()) 
	+ "," + std::to_string(col()) + "]";
}

int IntLitToken::num() const {
	return this->myNum;
}

} //End namespace cshanty
