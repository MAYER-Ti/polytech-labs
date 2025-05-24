! Задача 
! Множество из 50 точек задано своими координатами (x1,y1), ..., (x50,y50).
! Найти максимально (минимально) удаленную точку от начала координат (указать ее порядковый номер).
! Если есть одинаковые точки, то зафиксировать ближайшую к первой.
! Указания
! Искать расстояние не требуется - достаточно оценивать сумму квадратов. MaxLoc.

program exercise_7_46
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, i = 0, indexMaxSumSquare = 0
   real(R_), allocatable   :: Points(:,:)

   open (file=input_file, newunit=In)
      read (In, *) N
      allocate (Points(N, 2))
      read (In, *) (Points(i,:), i = 1, N)
   close (In)
   
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '(2f6.2)') (Points(i,:), i = 1, N)
   close (Out)
  
   indexMaxSumSquare = MaxLoc( (Points(:,1)*Points(:,1)) + (Points(:,2)*Points(:,2)) , 1)

   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, *)
      write (Out, '(A, i0)') "index of max sums square - ", indexMaxSumSquare 
   close (Out)
end program exercise_7_46
