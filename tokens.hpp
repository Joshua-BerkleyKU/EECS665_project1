#ifndef CSHANTY_TOKEN_HH
#define CSHANTY_TOKEN_HH

#include <string>

namespace cshanty{

class Token{
public:
	Token(size_t lineIn, size_t columnIn, int kindIn);
	virtual std::string toString();
	size_t line() const;
	size_t col() const;
	int kind() const;
private:
	const size_t myLine;
	const size_t myCol;
	const int myKind;
};

class IDToken : public Token{
public:
	IDToken(size_t lIn, size_t cIn, std::string valIn);
	const std::string value() const;
	virtual std::string toString() override;
private:
	const std::string myValue;
	
};

class StrToken : public Token{
public:
	StrToken(size_t lIn, size_t cIn, std::string valIn);
	virtual std::string toString() override;
	const std::string str() const;
private:
	const std::string myStr;
};

class IntLitToken : public Token{
public:
	IntLitToken(size_t lIn, size_t cIn, int numIn);
	virtual std::string toString() override;
	int num() const;
private:
	const int myNum;
};

}

#endif
