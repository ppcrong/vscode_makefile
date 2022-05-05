#
# 'make'        build executable file 'main'
# 'make clean'  removes all .o and executable files
#

# define the C compiler to use
CC = gcc
# define the Cpp compiler to use
CXX = g++

# define any compile-time flags
CFLAGS		:= -Wall -Wextra -g
CXXFLAGS	:= -std=c++17 -Wall -g

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
LFLAGS =

# define output directory
OUTPUT	:= output

# define source directory
SRC		:= src

# define include directory
INCLUDE	:= include

# define lib directory
LIB		:= lib

ifeq ($(OS),Windows_NT)
MAIN-C	:= main-c.exe
MAIN-CPP	:= main-cpp.exe
SOURCEDIRS	:= $(SRC)
INCLUDEDIRS	:= $(INCLUDE)
LIBDIRS		:= $(LIB)
FIXPATH = $(subst /,\,$1)
RM			:= del /q /f
MD	:= mkdir
else
MAIN-C	:= main-c
MAIN-CPP	:= main-cpp
SOURCEDIRS	:= $(shell find $(SRC) -type d)
INCLUDEDIRS	:= $(shell find $(INCLUDE) -type d)
LIBDIRS		:= $(shell find $(LIB) -type d)
FIXPATH = $1
RM = rm -f
MD	:= mkdir -p
endif

# define any directories containing header files other than /usr/include
INCLUDES	:= $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# define the C libs
LIBS		:= $(patsubst %,-L%, $(LIBDIRS:%/=%))

# define the C source files
SOURCES_C		:= $(wildcard $(patsubst %,%/*.c, $(SOURCEDIRS)))
SOURCES_CPP		:= $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))

# define the C object files 
OBJECTS-C		:= $(SOURCES_C:.c=.o)
OBJECTS-CPP		:= $(SOURCES_CPP:.cpp=.o)

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

OUTPUTMAIN-C	:= $(call FIXPATH,$(OUTPUT)/$(MAIN-C))
OUTPUTMAIN-CPP	:= $(call FIXPATH,$(OUTPUT)/$(MAIN-CPP))

all: $(OUTPUT) $(MAIN-C) $(MAIN-CPP)
	@echo Executing 'all' complete!

$(OUTPUT):
	$(MD) $(OUTPUT)

$(MAIN-C): $(OBJECTS-C) 
	$(CC) $(CFLAGS) $(INCLUDES) -o $(OUTPUTMAIN-C) $(OBJECTS-C) $(LFLAGS) $(LIBS)
$(MAIN-CPP): $(OBJECTS-CPP) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN-CPP) $(OBJECTS-CPP) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@
.cpp.o:
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<  -o $@

.PHONY: clean
clean:
	$(RM) $(OUTPUTMAIN-C)
	$(RM) $(OUTPUTMAIN-CPP)
	$(RM) $(call FIXPATH,$(OBJECTS-C))
	$(RM) $(call FIXPATH,$(OBJECTS-CPP))
	@echo Cleanup complete!

run: all
	./$(OUTPUTMAIN-C)
	./$(OUTPUTMAIN-CPP)
	@echo Executing 'run: all' complete!