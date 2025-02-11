! ex_3_15 вычислить сумму элементов побочной, идущей из левого нижнего к верхнему правому углу, диагонали квадратной матрицы B,
! содержащей 255 элементов.
! Указания:
! Сформировать массив из элементов побочной диагонали. Sum.
program ex_3_15
   use Environment

   implicit none
   character(*), parameter       :: fin = "../data/matrix.txt", fout = "../bin/output.txt"
   integer                       :: In = 0, Out = 0, m_size = 0
   integer, allocatable, target  :: B(:)
   ! integer, allocatable, target  :: B(:,:)
   integer, pointer          :: main_diag(:)
   integer, pointer          :: sec_diag(:)
   
   ! i - номер строки,   m_size - кол-во строк и столбцов
   ! j - номер столбца
   
   open (file=fin, newunit=In)
      read(In, *) m_size
      !allocate(B(m_size,m_size))
      allocate(B(m_size**2))
      !allocate(sec_diag(m_size))
      !read (In, *) (B(:, i), i = 1, m_size)
      read (In, *) B
   close(In)

   main_diag => B(1::m_size+1)
   sec_diag => B(m_size:m_size**2-1:m_size-1)
   
  ! do i = 1, m_size
  !    sec_diag(i) = B(i, m_size+1-i) 
  ! end do

   open (file=fout, newunit=Out)
      write (Out, "("//m_size//"i5)") B
      write (Out, '("Элементы главной диагонали - ",'//m_size//'i5)') main_diag
      write (Out, '("Элементы побочной диагонали - ",'//m_size//'i5)') sec_diag
      write (Out, '("Сумма элементов побочной диагонали - ", i6)') sum(sec_diag)
   close(Out)
end program ex_3_15

!переписать так, чтобы можно было смотреть на входную матрицу как на одномерный массив, сделать срез на количество элементов в строке
!+1 и собрать получившийся массив, посчитать сумму отдельно от блока вывода

