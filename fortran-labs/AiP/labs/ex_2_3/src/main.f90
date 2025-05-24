! Даны значения значения переменных a, b, c, d вещественного типа.
! Определить количество положительных значений среди заданных.

program ex_2_3 
   use ISO_Fortran_Env
   
   implicit none
   character(*), parameter    :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                    :: In = 0, Out = 0 ! , count = 0, i = 0
   integer, parameter         :: R_ = REAL32 ! kind(REAL32) = 4 - 4 байта как я понимаю. Точность до 7 знаков после запятой включительно
   real(R_)                   :: mass(1:4) = 0
   
   open (file=input_file, newunit=In) 
      read (In, *) mass
   close (In)
  
   open (file=output_file, newunit=Out, position="append")
      write (Out, '(4f7.3)')  mass(1:4) 
      write (Out, *) "--------------"
   close (Out)

   open (file=output_file, newunit=Out, position="append")
      write (Out, '("count - ", i1)')  count(mass > 0) 
     ! write(Out, *) kind(REAL32)
   close (Out)

end program ex_2_3
