####### BEGIN DEFINITIONS **********
# The lines below define variables that 
# will be used in later Make rules

# This is a simple variable definition
# that creates a variable which can 
# be referenced later in the rules
# By defining our build programs this
# way, we can easily change the program
# without having to search for every use
# throughout the Makefile
LEXER_TOOL := flex

# Here we'll define the c++ compiler for
# use in rules below. For now we'll use
# g++, but if we wanted to switch to clang
# it would be as simple as changing this one
# line. 
CXX := g++

# This variable resolves to the list of all
# files in the current directory ending in 
# .cpp. It's helpful to pattern-match like
# this so that if we add another .cpp file
# we don't have to manually edit the makefile
CPP_SRCS := $(wildcard *.cpp) 

# This variable creates a list of all of the 
# .o files that will be needed to build the 
# final program. It cannot be wildcarded,
# because the .o files do not exist on a clean
# build. However, the list can be built by
# replacing the ".cpp" with ".o" in all of the 
# cpp files we collected above. Additionally, 
# the lexer.o file  is added to the list, since
# it will also be needed but does not correspond
# to any .cpp file. 
OBJ_SRCS := lexer.o $(CPP_SRCS:.cpp=.o)

# This variable is a list of all of the dependency
# files, created using a similar list-replacement
# operation to how the list of object files was
# built. The dependency files are also generated
# as part of the build process. The .d files
# will be described in more detail below.
DEPS := $(OBJ_SRCS:.o=.d)

# This directive specifies that the "all",
# "clean", "test", and "cleantest" targets are 
# fake targets that do not check dependencies
# and should run every time they are invoked
.PHONY: all clean test cleantest

####### END DEFINITIONS **********


####### BEGIN RULES **********
# Most of a makefile is usally rules, which
# have the format 
#
# target: [ dependencies ]+
#	action1
#	action2
#	...
#
# The basic idea is that an when a rule is invoked, it
# will check if the target is "already prepared" (i.e.
# it exists and is fresher than all of it's dependencies.
# If the rule is not already prepared, then it will invoke
# each of the actions and assume that those actions
# suffice to prepare the target. We'll go through some
# examples below

# The first target is run by default if no command line 
# argument is provided. As such, running "make all" is 
# equivalent to runnign "make".
# In this case, the all target is phony so it is 
# never considered to be already prepared and always
# runs its action (which is to call "make cshantyc")
# ---------------------------------------------
all: 
	make cshantyc

# Make clean is also a phony target, so it runs every
# time "make clean" is invoked. Here, it simply deletes
# each of the automatically generated files in the build
# ---------------------------------------------
clean:
	rm -rf *.o *.cc $(DEPS) cshantyc

# The -include says to (conceptually) paste the text
# of it's arguments directly into the body of the make file.
# in this case, it pastes all of the .d files (the list
# generated above) into this text file. Each .d file contains
# rules for any internal dependencies that a  c++ source code 
# file might have. For example, the .d file for scanner.cpp
# has a #include for scanner.hpp, which in turn has a #include
# for tokens.hpp and grammar.hh, which in turn has a #include for 
# stack.hh. The scanner.d file collects all of these
# dependencies. Note that in a clean codebase, no .d files
# will be present. That's ok, because every piece of the
# codebase needs to be built in a clean codebase. 
# ---------------------------------------------
-include $(DEPS)

# Build the executable program, which depends on all of the 
# object files for freshness. The single action is a call to
# the c++ compiler to link together all of the .o files into
# single binary named cshantyc (the -o argument). 
# The $@ is an automatic variable that takes on whatever the 
# target of the rule is. So, in this case, since the target
# of the rule is cshantyc, $@ resolves to cshantyc. 
# It often handy to have an action write to $@ since 
# that is the # file that we are trying to prepare 
# in a given rule. 
# ---------------------------------------------
cshantyc: $(OBJ_SRCS)
	$(CXX) -g -std=c++14 -o $@ $(OBJ_SRCS)

# This rule is actually a pattern to match multiple rules. 
# Any file name <f> ending in .o depends on <f>.cpp
# and is satisfied by a single action that calls the c++
# compiler. Note here the difference with the cshantyc rule:
# the additional -c argument says to compile an object file
# rather than a binary program. The input file is supplied as
# $<, which is just the name of the first dependency of the rule
# (which in this case is the <f>.cpp file).
# The -MMD and -MP tells the c++ compiler to output, in addition
# to the object file, a .d file tha collects all of the code
# dependencies. 
# ---------------------------------------------
%.o: %.cpp 
	$(CXX) -g -std=c++14 -MMD -MP -c -o $@ $<

# Unlike the other source code files, lexer.yy.cc is not 
# hand-coded. Instead, it is the output of running flex on 
# cshanty.l (hence cshanty.l is a dependency of lexer.yy.cc). 
# Consequently, it requires a rule to describe how it is 
# generated (which is, of course, an invocation of flex). 
# ---------------------------------------------
lexer.yy.cc: cshanty.l
	$(LEXER_TOOL) --outfile=lexer.yy.cc $<

# Unlike the other object files, lexer.o cannot come from 
# lexer.cpp because there is no lexer.cpp. Instead, it depends
# on lexer.yy.cc. This rule is an example of overriding a pattern,
# since it takes precedence over lexer.yy.cc
# ---------------------------------------------
lexer.o: lexer.yy.cc
	$(CXX) -g -std=c++14 -c lexer.yy.cc -o lexer.o

# Run the program on test1.cshanty, writing the
# output to test1.out and redirecting error text to
# test1.err.
# Check the newly-generated test1.out against the
# pre-generated test1.out.expected, which contains 
# what we expect test1.out SHOULD contain. 
# Check the newly-generated test1.err against the
# pre-generated test1.err.expected, which contains
# what we expect the error output from running   
# on test1.cshanty should be. 
# Note that if the diff detects a difference, it 
# will exit with a non-zero status code, which 
# will cause the action sequence to halt
# and force Make to exit with an error as well. 
# You'll want to add actions so that any additional
# test files are also exercised and checked by 
# running this target
# TODO: You will need to add to this rule to 
# handle additional test cases
# ---------------------------------------------
test: all
	./cshantyc test1.cshanty -t test1.out 2> test1.err
	diff test1.out test1.out.expected
	diff test1.err test1.err.expected

# Remove all files automatically generated by make test
# TODO: You will need to add to this rule to clean
# up after additional test cases. 
# ---------------------------------------------
cleantest:
	rm -f test1.out test1.err
	
