! Задание
!  В квадратной матрице C (15,15) поменять местами элементы диагоналей (главной и побочной), расположенные в одной строке
! Указания
! do concurrent 

program exercise_7_28
   use Environment
   use Matrix_IO
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: N = 0, M, i = 0
   real(R_), allocatable   :: C(:,:)
   real(R_)                :: temp = 0

   ! Ввод данных.
   call ReadMatrix(input_file, C, N, M) 

   ! Вывод данных.
   call WriteMatrix(output_file, C) 
   
   !Обработка данных 
   !Достижение оптимизации засчет распараллеливания
   do concurrent (i=1:N)  
      temp = C(i, i)
      C(i, i) = C( n - i + 1, i)
      C(n - i + 1,i) = temp 
   end do

   ! Вывод данных.
   call WriteMatrix(output_file, C) 



end program exercise_7_28
