FC=gfortran
FFLAGS=-Wall -std=f2008 -fimplicit-none -Wno-maybe-uninitialized -Wno-unused-function -static-libgfortran -flto
FOPT=-O3 -ftree-vectorize -fopt-info-vec

all:
	$(FC) $(FFLAGS) -c src/DECOMP.F -o obj/DECOMP.o
	$(FC) $(FFLAGS) -c src/SOLVE.F -o obj/SOLVE.o
	$(FC) $(FFLAGS) -c src/main.f90 -o obj/main.o
	$(FC) $(FFLAGS) $(FOPT) -o bin/app obj/main.o obj/SOLVE.o obj/DECOMP.o

run:
	cd ./bin; ./app;
