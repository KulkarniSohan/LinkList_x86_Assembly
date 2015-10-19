AS=as
LD=ld
ASFLAGS=-g -o
LDFLAGS=-o
LIBS=-lc
DYNAMIC=/lib/ld-linux.so.2
EXE=linklist


target:doubly_linklist main_compile
doubly_linklist:
	cd ./src/doubly_linklist/ && make
main_compile:
	$(AS) $(ASFLAGS) doubly_main.o doubly_main.S
	cp -rf ./doubly_main.o ./bin/

target_link:link
link:
	$(LD) $(LDFLAGS) $(EXE) $(LIBS) -dynamic-linker $(DYNAMIC) ./bin/doubly_linklist.o ./bin/doubly_main.o -e main
	cp -rf ./linklist ./bin/

target_clean:doubly_linklist_clean main_clean
doubly_linklist_clean:
	cd ./src/doubly_linklist/ && rm *.o
main_clean:
	rm *.o 
	rm $(EXE)
	cd ./bin/ && rm *.o 
	cd ./bin/ && rm $(EXE)
