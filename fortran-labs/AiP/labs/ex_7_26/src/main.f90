! Задание ex_7_26
! Заменить k-ю строку матрицы A(50,50) заданным вектором X(50), а i-й столбец - вектором Y(50)
! Указания
! Использовать сечения двумерного массива

program exercise_7_26
   use Environment

   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, j = 0, k = 0, g = 0
   real(R_), allocatable   :: A(:, :) 
   real(R_), allocatable   :: X(:), Y(:)
   ! i - строка, j - столбец
   ! k - индекс строки для изменения
   ! g - индекс столбца для изменения
   open (file=input_file, newunit=In)
      read (In, *) N
      allocate (A(N, N))
      read (In, *) (A(:, j), j = 1, N)
      allocate (X(N))
      allocate (Y(N))
      read (In, *) X
      read (In, *) Y
      read (In, *) k, g 
   close (In)
   
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '('//N//'f6.2)') (A(:, j), j = 1, N)
   close (Out)
   
   A(k, :) = X
   A(:, g) = Y
  
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, *)
      write (Out, '('//N//'f6.2)') (A(:, j), j = 1, N)
   close (Out)

end program exercise_7_26
