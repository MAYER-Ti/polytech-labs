! Задание ex_7_6
! Вычислить значение величины s - Произведение суммы строк квадратов элементов матрицы.
! Если матрица A=(aij) квадратная и содержит 900 элементов.
! Указания
! Вычисления провести, используя два подхода: 
! 1) Sum, Product, SqRt;
! 2) Norm2, Product;

program exercise_7_6
   use Environment
   use MatrixIO
   implicit none
   character(*), parameter       :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                       :: Out = 0, N = 0, M
   real(R_), allocatable         :: A(:, :) 
   real(R_)                      :: res1 = 0, res2 = 0
   ! Ввод данных
   call ReadMatrix(input_file, A, N, M) 
   !Вывод данных 
   call WriteMatrix(output_file, A) 
      
   !Обработка данных
   res2 = Product(Norm2(A,2)) 
   A = A * A
   res1 = SqRt(Product(Sum(A,2),N))

   !Вывод данных
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write(Out, *) "1) ", res1
      write(Out, *) "2) ", res2
   close (Out)
end program exercise_7_6
