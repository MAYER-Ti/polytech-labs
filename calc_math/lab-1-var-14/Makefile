FC=gfortran
FFLAGS=-Wall -std=f2008 -fimplicit-none -Wno-maybe-uninitialized -Wno-unused-function -flto
FOPT=-O3 -ftree-vectorize -fopt-info-vec

all:
	$(FC) $(FFLAGS) -c src/SPLINE.F -o obj/SPLINE.o
	$(FC) $(FFLAGS) -c src/SEVAL.F -o obj/SEVAL.o
	$(FC) $(FFLAGS) -c src/QUANC8.F -o obj/QUANC8.o
	$(FC) $(FFLAGS) -c src/integral_func.f90 -o obj/integral_func.o
	$(FC) $(FFLAGS) -c src/main.f90 -o obj/main.o
	$(FC) $(FFLAGS) $(FOPT) -o bin/app obj/integral_func.o obj/QUANC8.o obj/SEVAL.o obj/SPLINE.o obj/main.o 

run:
	cd ./bin; ./app;
