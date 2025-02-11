! Задание:
! Протабулировать функции одной переменной:
! f(x) = (x**2)*tan(x)+(sin(x)/x)
! 0.01254 <= x <= 0.03254 
! dx = 0.0002
! Указание:
! Сформировать вектор X(N), а потом F(N)
program ex_4_1v
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, i = 0
   real(R_)                :: x1 = 0, x2 = 0, dx = 0
   real(R_), allocatable   :: X(:), F(:) 
   
   open (file=input_file, newunit=In)
      read (In, *) x1, x2, dx
   close (In)
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '(3(a, T4, "= ", f0.4/))') "x1", x1, "x2", x2, "h", dx
   close (Out)
   
   N = Int((x2-x1) / dx + .5_R_)+ 1
   allocate (X(N), F(N))
  
   call TabF(x1, dx, X, F)
  
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, '("  X", T8, " | ","   f")')
      write (Out, '(f0.4, T8, " | ", f0.7)') (X(i), F(i), i = 1, N)
   close (Out)

contains
   pure subroutine TabF(x1, dx, X, F)
      real(R_)    x1, dx, X(:), F(:)
      intent(in)  x1, dx
      intent(out) X, F
      
      X = [(x1 + dx*(i-1), i = 1, Size(X))]
      F = (X**2)*tan(X)+(sin(X)/X)

   end subroutine TabF

end program ex_4_1v
