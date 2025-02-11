! Задание 
! Упорядочить числовую последовательность a1, a2, a3, ... , a100 так, чтобы:
! |ai| >= |ai+1|
! Указания по сортировке
! Используйте функции Count, MinLoc, MaxLoc, CShift в 
! зависимости от метода сортировки, заменяя этими функциями
! внутренний цикл сортировки.
! Указания к 7.1в-г
! Вычислять модуль элементов каждый раз неэффективно.
! Перед сортировкой лучше сформировать только массив из модулей
! элементов AbsA(:). Сортируя первый из них, сортировать основной.

program exercise_7_1g
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0
   real(R_), allocatable   :: Z(:)

   open (file=input_file, newunit=In)
      read (In, *) N
      allocate (Z(N))
      read (In, *) Z
   close (In)

   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '('//N//'f6.2)') Z
   close (Out)


   ! Размещение массивов в НАЧАЛЕ работы программы,
   ! а не внутри процедур при КАЖДОМ их вызове.
   call SortModulDown(Z, N)

   open (file=output_file, encoding=E_, newunit=Out, position='append')
   write (Out, '('//N//'f6.2)') Z
   close (Out)

contains
   ! Чистая функция в исперативном стиле.
   pure subroutine SortModulDown(Z, N) 
      real(R_), intent(inout) :: Z(:)
      integer, intent(in)     :: N

      integer  i, maxInd
      real(R_) absZ(N) 
      !dir$ attributes align:32::Z
      ! Сортировка по условию |ai| >= |ai+1|
      !dir$ vector aligned
      absZ= abs(Z)
      do i = 1, n-1
        maxInd = MaxLoc(absZ(i:N), 1) + i - 1
        absZ(i:N) = CShift(absZ(i:N), maxInd-i)
        Z(i:N) = CShift(Z(i:N), maxInd-i) 
      end do

   end subroutine SortModulDown
end program exercise_7_1g
