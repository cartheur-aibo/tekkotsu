LEGACY_CXXFLAGS=-O3 -std=gnu++03

all: EmonLog.o  Function.o  FunctionStore.o  StackAnalyser.o  StackDump.o  main.o
	$(CXX) -o ../StackedIt EmonLog.o  Function.o  FunctionStore.o  StackAnalyser.o  StackDump.o  main.o 

Function.o: Function.cc Function.h
	$(CXX) -c $(LEGACY_CXXFLAGS) Function.cc

FunctionStore.o: FunctionStore.cc FunctionStore.h Function.h 
	$(CXX) -c $(LEGACY_CXXFLAGS) FunctionStore.cc

StackAnalyser.o: StackAnalyser.cc StackAnalyser.h StackDump.h FunctionStore.h Function.h Trace.h
	$(CXX) -c $(LEGACY_CXXFLAGS) StackAnalyser.cc

StackDump.o: StackDump.cc StackDump.h 
	$(CXX) -c $(LEGACY_CXXFLAGS) StackDump.cc

main.o: main.cc StackDump.h FunctionStore.h Function.h StackAnalyser.h
	$(CXX) -c $(LEGACY_CXXFLAGS) main.cc

EmonLog.o:	EmonLog.h EmonLog.cc
	$(CXX) -c $(LEGACY_CXXFLAGS) EmonLog.cc

clean:
	rm -f *.o ../StackedIt ../StackedIt.exe
