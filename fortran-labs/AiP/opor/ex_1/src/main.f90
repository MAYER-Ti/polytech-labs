program exercise_1 
   use Environment
   
   implicit none
   character(*), parameter    :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                    :: In = 0, Out = 0
   complex(R_)                :: x = 0, y = (0, 0), z = (0, 0)
   character(:), allocatable  :: fmt

   ! UTF-8 ASCII Unicode
   ! s ё 爱 
   open (file=input_file, encoding=E_, newunit=In) ! unit = 1 -- плохо
      read (In, '(2f5.2)') x, y ! '(f5.2,f5.2)'
   close (In)

   open (file=output_file, encoding=E_, newunit=Out)
      fmt = "(a, f0.2, ', ', f0.2, ')')" 
      write (Out, fmt) "x = (", x
      write (Out, fmt) "y = (", y
   close (Out)

   z = x / y
   
   open (file=output_file, encoding=E_, newunit=Out, position="append")
      write (Out, *)
      write (Out, fmt) "z = (", z
   close (Out)
end program exercise_1
