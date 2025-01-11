RUNTIME:=$(if $(RUNTIME),$(RUNTIME),linux)
TARGET_EXEC:=builds/$(RUNTIME)/zelda3
ROM:=extras/zelda3.sfc
SRCS:=$(wildcard src/*.c src/snes/*.c) other/third_party/gl_core/gl_core_3_1.c other/third_party/opus-1.3.1-stripped/opus_decoder_amalgam.c
OBJS:=$(SRCS:%.c=%.o)
PYTHON:=/usr/bin/env python3
CFLAGS:=$(if $(CFLAGS),$(CFLAGS),-O2 -Werror) -I .
CFLAGS2:=$(shell sdl2-config --cflags) -DSYSTEM_VOLUME_MIXER_AVAILABLE=0
ROM_TRANSLATED:=extras/zelda3-$(LANGUAGE).sfc

ifeq (${RUNTIME},windows)
	RES:=assets/zelda3.res
	TARGET_EXEC:=$(TARGET_EXEC).exe

# 	Configura o destino para Windows
	ifeq (${OS},Windows_NT)
# 		Se já estiver no Windows seta o windres como "windres" que precisa estar instalado
		WINDRES:windres
	else
# 		Se estivermos no Linux usa o cross-compiler para Windows
		SDL2_DLL:=builds/$(RUNTIME)/SDL2.dll
		SDLFOLDER:=extras/SDL2
		MINGW32:=x86_64-w64-mingw32
		CFLAGS2:=-I$(SDLFOLDER)/include/SDL2 -Dmain=SDL_main -DSYSTEM_VOLUME_MIXER_AVAILABLE=0
		WINDRES:=$(MINGW32)-windres
		CC:=$(MINGW32)-gcc-9
		SDLFLAGS:=-static-libgcc -static-libstdc++ -Wl,-Bstatic -L$(SDLFOLDER)/lib -lSDL2 -I$(SDLFOLDER)/include/SDL2 -lSDL2main $(SDLFOLDER)/lib/libSDL2.a -lmingw32 -mwindows -lm -lkernel32 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lversion -luuid -ladvapi32 -lsetupapi -lshell32 -ldinput8
	endif
else
# 	Configura o destino para Linux
	SDLFLAGS:=-lSDL2 -lm
endif

all: builds/$(RUNTIME)/zelda3_assets.dat $(TARGET_EXEC) $(SDL2_DLL) builds/$(RUNTIME)/zelda3.ini clean

builds/$(RUNTIME)/zelda3_assets.dat: assets assets/dialogue.txt assets/dialogue_${LANGUAGE}.txt
	@echo "Gerando o zelda3_assets.dat"
	$(PYTHON) extract_assets/restool.py $(if ${LANGUAGE},--languages=${LANGUAGE},) -r ${ROM} --dat-path=/zelda3/builds/$(RUNTIME) --assets-path=/zelda3/assets

assets:
	@mkdir -p assets

assets/dialogue.txt:
	@echo "Extraindo os assets da ROM"
	$(PYTHON) extract_assets/restool.py --extract-from-rom -r ${ROM} --no-build --assets-path=/zelda3/assets

assets/dialogue_${LANGUAGE}.txt:
ifneq ($(wildcard ${ROM_TRANSLATED}),)
	@echo "Extraindo a tradução da ROM"
	$(PYTHON) extract_assets/restool.py --extract-dialogue -r ${ROM_TRANSLATED} --no-build --assets-path=/zelda3/assets
endif

$(TARGET_EXEC): $(OBJS) $(RES)
	$(CC) $^ -o $@ $(LDFLAGS) $(SDLFLAGS)
%.o : %.c
	$(CC) -c $(CFLAGS) $(CFLAGS2) $< -o $@

$(RES): platform/win32/zelda3.rc
	@echo "Generating Windows resources"
	@$(WINDRES) $< -O coff -o $@

$(SDL2_DLL): ${SDLFOLDER}/bin/SDL2.dll
	@echo "Copiando o SDL2.dll"
	cp ${SDLFOLDER}/bin/SDL2.dll builds/$(RUNTIME)

builds/$(RUNTIME)/zelda3.ini: other/zelda3.ini
	@echo "Copiando o zelda3.ini"
	cp other/zelda3.ini builds/$(RUNTIME)

clean:
	@$(RM) $(OBJS)
	@$(RM) -rf assets extract_assets/__pycache__
