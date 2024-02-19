target=genfile.out

CFLAGS=-ggdb
OBJS=main.o
LIBS=
INC=
CXX=gcc

$(target): $(OBJS)
	$(CXX) -o $(target) $^ $(LIBS)

main.o: main.c
	$(CXX) -c $< $(CFLAGS) $(INC)
