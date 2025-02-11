! Задание Вычислить нормы квадратной матрицы A, содержащей 100 элементов (N = 10):
! б) ||A|| = max(j) sum(i = 1,N) |a(i,j)|
! Указания
! MaxVal, Sum с параметром dim, Abs

! Найти сумму каждой строки матрицы по модулю
! Найти максимальное из этих сумм 

program exercise_7_9b
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, i = 0
   real(R_), allocatable   :: A(:, :)
   real(R_)                :: maxZ = 0
   
   !Ввод данных
   open (file=input_file, newunit=In)
      read (In, *) N
      allocate (A(N, N))
      read (In, *) (A(:, i), i = 1, N)
   close (In)
   !Вывод данных 
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '('//N//'f6.2)') (A(:, i), i = 1, N)
   close (Out)
   !Обработка данных
   maxZ = MaxVal([(Sum(Abs(A(:, i)),1), i = 1, N)], 1)
   !Вывод данных
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, '(a, T5, "= ", f9.2)') "Sum", maxZ
   close (Out)
end program exercise_7_9b
