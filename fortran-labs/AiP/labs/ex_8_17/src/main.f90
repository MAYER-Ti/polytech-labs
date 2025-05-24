! Задание
! Составить процедуру вычисления следа матрицы A(N,N).
! Используя ее, определить, у какой из заданных матриц С(10,10) или D(10,10) значение следа больше
! Условия
! Реализация проводится с модулями.
! Все процедуры, предлагаемые для разработки, должны быть чистыми - иметь квалификатор pure. 
! Они не должны использовать встроенные функции по обработке массивов или сечений.
!   8.17 
!   Сделать отображение ранга ссылки, взглянув на двумерную матрицу как на одномерный массив.
!   Просумировать в одномерном массиве каждый N+1-ый элемент (UBound).
!   Матрицу принимаем как target, contiguous, intent(inout)

program exercise_8_17
   use Environment
   use MatrixIO
   use SumDiagMatrix

   implicit none
   character(*), parameter :: inFile_matrix1 = "../data/matrix1.txt",  inFile_matrix2 = "../data/matrix2.txt" 
   character(*), parameter :: inFile_matrix3 = "../data/matrix3.txt", output_file     = "output.txt"
   integer                 :: Out = 0
   real(R_), allocatable   :: A(:,:), C(:,:), D(:,:)
   real(R_)                :: sumA, sumC, sumD
   ! Чтение входных данных
   call ReadMatrix(inFile_matrix1, A)
   call ReadMatrix(inFile_matrix2, C)
   call ReadMatrix(inFile_matrix3, D) 
   
   ! Вывод входных данных
   call WriteMatrix(output_file, A)
   call WriteMatrix(output_file, C)
   call WriteMatrix(output_file, D)

   ! Обработка данных
   call SumDiag(A, sumA)
   call SumDiag(C, sumC)
   call SumDiag(D, sumD) 

   ! Вывод обработанных данных 
   open (file=output_file, newunit=Out, position='append')
      write (Out, '(3(A, f6.2, " "))') "Ранг A - ", sumA, "Ранг С - ", sumC, "Ранг D - ", sumD
   close (Out)

end program exercise_8_17
