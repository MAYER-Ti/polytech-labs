! Задание 7_4
! В массиве А(10) с элементами, упорядоченными по возростанию, исключить пятый элемент, добавив вместо него заданное значение
! и оставляя массив упорядоченным.
! Указания
! Определить положение pos первого элемента, меньшего N. 
! Записать входное значение N на 5-ый элемент массива. 
! В зависимости от значения pos провести циклический
! сдвиг одного из двух сечений: C(pos:5) или C(5:pos) (не всего массива), 
! присвоив результат сдвига к тому же сечению. 
! Например: для C == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] и N == 2,5 необходимо
! циклически сдвинуть сечение C[3:5] == [3, 4, 2,5], чтобы получить C[3:5] == [2,5 3, 4]. 
! Также учесть случай, когда вставленный элемент самый большой. В задании использовать FindLoc.

program exercise_7_4
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, A_size = 0
   real(R_), allocatable   :: A(:)
   real(R_)                :: N = 0

   open (file=input_file, newunit=In)
      read (In, *) A_size
      allocate (A(A_size))
      read (In, *) A
      read (In, *) N
   close (In)

   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '('//A_size//'f6.2)') A
      write (Out, '(a,f6.2)') "N = ", N
   close (Out)

   call ChangeFive(A, N)

   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, '('//A_size//'f6.2)') A
   close (Out)

! найти индекс(pos) последнего элемента меньше N. Сделать сдвиг с pos по 5 в сторону 5 так, чтобы 5 исчезла. Вставить на место pos
! значение N.
contains
   ! Чистая функция в регулярном стиле.
   pure subroutine ChangeFive(A, N)
      real(R_)       A(:), N
      intent(in)     N
      intent(inout)  A
      integer        pos
       
      pos =  MaxLoc(A, 1, A <= N)
      if (pos < 5) then
         A(pos:5) = cshift(A(pos:5), -1)
         A(pos) = N
      else if (pos > 5) then
         A(5:pos) = cshift(A(5:pos), 1)
         A(pos) = N 
      end if
      if (findloc(A, N, 1) > A_size) then
         A(A_size) = N
      end if
   end subroutine ChangeFive
end program exercise_7_4
