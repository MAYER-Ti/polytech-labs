FC=nasm
LC=ld        # Используем gcc для компиляции и линковки с библиотекой C
FFLAGS=-f elf64


all:
		$(FC) $(FFLAGS) src/main.asm -o obj/main.o
		$(FC) $(FFLAGS) src/decline_lastname_macro.asm -o obj/decline_lastname_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_nominative_macro.asm -o obj/decline_lastname_nominative_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_roditive_macro.asm -o obj/decline_lastname_roditive_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_vinitive_macro.asm -o obj/decline_lastname_vinitive_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_tvoritive_macro.asm -o obj/decline_lastname_tvoritive_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_dative_macro.asm -o obj/decline_lastname_dative_macro.o
		$(FC) $(FFLAGS) src/decline_lastname_predlositive_macro.asm -o obj/decline_lastname_predlositive_macro.o
# Линковка с использованием gcc, добавляя флаги для подключения стандартной библиотеки C
		${LC}  obj/main.o obj/decline_lastname_macro.o obj/decline_lastname_dative_macro.o obj/decline_lastname_vinitive_macro.o obj/decline_lastname_roditive_macro.o obj/decline_lastname_tvoritive_macro.o obj/decline_lastname_nominative_macro.o obj/decline_lastname_predlositive_macro.o -o bin/app 

run:
		cd ./bin; ./app;

clean:
		rm -rf obj/*
		rm -rf bin/*

