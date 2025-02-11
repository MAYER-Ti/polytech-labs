! Задача:
! Дан массив X(25). Зафиксировать индексы элементов, значение которых:
! г) принадлежит интервалу (c, d), значения c, d заданы.
! Указания:
! Завести массив индексов. Построить массив-маску, удовлетворяющую заданному условию. Pack.

program ex_5_14g
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, c = 0, d = 0, i = 0
   integer, allocatable    :: X(:), Pos(:)
   logical, allocatable    :: Mask(:)

   open (file=input_file, newunit=In)
      read (In, *) N
      allocate (X(N))
      read (In, *) X
      read (In, *) c, d
   close (In)

   allocate(Mask(N))
   !call ContainBelow(X, Mask, c, d, Pos)

   Mask = c < X .and. X < d
   Pos = Pack([(i, i=1,N)], Mask)

   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, "(i3)") N
      write (Out, "(a,T8,"//N//"(i3))") "X =", X
      write (Out, "(a,T8,"//N//"(l3))") "Mask =", Mask 
      write (Out, '("Интервал от ",i3," до ",i3)') c, d
      write (Out, "(a,"//Size(Pos)//"i3)") "Индексы =", Pos
   close (Out)

contains
   pure subroutine ContainBelow(X, Mask, c, d, Pos)
      integer     X(:), Pos(:), c, d
      logical     Mask(:)
      intent(in)  X, c, d
      intent(out) Pos, Mask
      integer     i
       
      Mask = c < X .and. X < d
      Pos = Pack([(i, i=1,N)], Mask)

   end subroutine ContainBelow
end program ex_5_14g

