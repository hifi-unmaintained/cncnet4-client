CC=i586-mingw32msvc-gcc
CFLAGS=-O2 -s -Wall -g0
WINDRES=i586-mingw32msvc-windres
LIBS=-lws2_32
GIT_COMMIT_SHA1_SHORT=$(shell sh -c 'git rev-parse --short @{0}')

all: dll

dll: src/cncnet.c src/net.c
	sed 's/__GIT_COMMIT_SHA1_SHORT__/$(GIT_COMMIT_SHA1_SHORT)/g' res/dll.rc.in | sed 's/__FILE__/cncnet/g' | sed 's/__GAME__/CnCNet Internet DLL/g' | $(WINDRES) -O coff -o res/dll.o
	$(CC) $(CFLAGS) -DGIT_COMMIT_SHA1_SHORT=\"$(GIT_COMMIT_SHA1_SHORT)\" -Wl,--enable-stdcall-fixup -shared -s -o cncnet.dll src/cncnet.c src/net.c src/cncnet.def res/dll.o $(LIBS)

clean:
	rm -f cncnet.dll res/*.o
