! Задача 
! Матрицу С(30,30) преобразовать в одномерный массив, просматривая C по строкам и выбрасывая отрицательные элементы.
! Указания
! Pack
program exercise_7_51
   use Environment
   use MatrixIO 
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: Out = 0, N = 0, M = 0
   real(R_), allocatable   :: C(:,:), res(:)
   logical, allocatable    :: Mask(:,:)


   call ReadMatrix(input_file, C, N, M)

   call WriteMatrix(output_file, C) 

   Mask = C >= 0
   res = Pack(C, Mask)
   
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, *) "Массив без отрицательных значений - "
      write (Out, '('//UBound(res,1)//'f6.2)') res 
   close (Out)
end program exercise_7_51
