FC = gfortran
FFLAGS = -Wall -std=f2008  -Wno-maybe-uninitialized -Wno-unused-function -flto
FOPT = -O3 -ftree-vectorize -fopt-info-vec

# Правила для компиляции Fortran 77
%.o: src/%.F
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c $< -o $@

# Правило для компиляции modern Fortran
%.o: src/%.f90
	$(FC) $(FFLAGS) -c $< -o $@

all:
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/FEHL.F -o obj/FEHL.o
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/RKF45.F -o obj/RKF45.o
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/RKFS.F -o obj/RKFS.o
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/QUANC8.F -o obj/QUANC8.o
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/DECOMP.F -o obj/DECOMP.o
	$(FC) $(FFLAGS) -std=legacy -ffixed-form -c src/SOLVE.F -o obj/SOLVE.o
	$(FC) $(FFLAGS) -fimplicit-none -c src/main.f90 -o obj/main.o
	$(FC) $(FFLAGS) $(FOPT) -o bin/app obj/main.o obj/FEHL.o obj/RKFS.o obj/RKF45.o obj/SOLVE.o obj/DECOMP.o obj/QUANC8.o



clean:
	rm -f obj/*.o bin/app

run:
	cd bin; ./app
