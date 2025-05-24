! Задание
! Найти число элементов матрицы B(15, 25), являющиеся:
! г) имеющий занчения, принадлежащие заданному отрезку [a, c]
! Напечатать индексы элементов, обладающих каждыми из этих свойств
! Указания
! Count. Составить маску. Упаковать массив индексов.

program exercise_7_19v
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0, N = 0, M = 0, i = 0 
   real(R_)                :: rangeMin = 0, rangeMax = 0
   real(R_), allocatable   :: B(:,:)
   integer, allocatable    :: Indexes(:,:), IndexesOfRange(:,:)
   logical, allocatable    :: Mask(:)
   ! a = rangeMin, c = rangeMax
   ! i - строка, j - столбец
   ! Ввод данных.
   open (file=input_file, newunit=In)
      read (In, *) N, M
      allocate (B(N, M))
      read (In, *) (B(i, :), i = 1, N)
      read (In, *) rangeMin, rangeMax
   close (In)

   ! Вывод данных.
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '(a,2i3)') "Размер матрицы:", N, M
      write (Out, '(a)') "Матрица:" 
      write (Out, '('//M//'f6.2)') (B(i, :), i = 1, N)
   close (Out)

   ! Размещение массивов в НАЧАЛЕ работы программы,
   ! а не внутри подпрограмм при КАЖДОМ их вызове.
   allocate (Indexes(N*M, 2))
   allocate (Mask(N*M), source=.false.)
   call ArrayIndexOfRange(B, Indexes, Mask, IndexesOfRange, rangeMin, rangeMax)
   
   open (file=output_file, encoding=E_, newunit=Out, position='append')
      write (Out, '( a , "[" , f0.2 , ", " , f0.2 , "]" )') "Диапазон значений: ", rangeMin, rangeMax
      write (Out, '( "(" , i0 , ", " , i0 , ")" )') (IndexesOfRange(i, :), i = 1, UBound(IndexesOfRange, 1))
   close (Out)

contains
   pure subroutine ArrayIndexOfRange(B, Indexes, Mask, IndexesOfRange, rangeMin, rangeMax)
     real(R_), intent(in) :: B(:,:), rangeMin, rangeMax
     integer, intent(out) :: Indexes(:,:)
     logical, intent(out) :: Mask(:) 
     integer, allocatable, intent(out) :: IndexesOfRange(:,:)
     
     integer :: IndexesOfRangeSize, i, j

     Mask = [rangeMin <= B .and. B <= rangeMax] 
     IndexesOfRangeSize = Count(Mask)
     allocate(IndexesOfRange(IndexesOfRangeSize, 2)) 
     Indexes(:, 1) = [((i, i = 1, N), j = 1, M)]
     Indexes(:, 2) = [((j, i = 1, N), j = 1, M)]
     
     IndexesOfRange(:, 1) = Pack(Indexes(:, 1), Mask)
     IndexesOfRange(:, 2) = Pack(Indexes(:, 2), Mask)

   end subroutine ArrayIndexOfRange 
   ! Чистая подпрограмма в регулярном стиле.
   pure subroutine MaxNegAndMinPos(C, max_neg, min_pos, Mask, Indexes, Ind_max_neg, Ind_min_pos)
      real(R_), intent(in)    :: C(:, :)
      real(R_), intent(out)   :: max_neg, min_pos
      integer, intent(out)    :: Indexes(:, :)
      integer, allocatable, intent(out) :: Ind_max_neg(:, :), Ind_min_pos(:, :)
      logical, intent(out)    :: Mask(:)

      integer N_max_neg, N_min_pos, i, j

      ! Формируем двумерный массив индексов:
      ! | 1 | 1 |
      ! | 2 | 1 |
      ! ...
      ! | N | 1 |
      ! ...
      ! | 1 | 2 |
      ! | 2 | 2 |
      ! ...
      ! | N | 2 |
      ! ...
      ! | 1 | M |
      ! | 2 | M |
      ! ...
      ! | N | M |
      Indexes(:, 1) = [((i, i = 1, N), j = 1, M)]
      Indexes(:, 2) = [((j, i = 1, N), j = 1, M)]

      ! Поиск наибольшего из отрицательных.
      max_neg = MaxVal(C, C < 0)
      ! Получаем маску для элементов, равных наибольшему из отрицательных.
      Mask        = [C == max_neg]
      N_max_neg   = Count(Mask)

      ! Формируем массив индексов, удовлетворяющих заданной маске:

      ! Размещение массивов индексов.
      allocate(Ind_max_neg(N_max_neg, 2))
      ! Упаковка массива индексов по каждой из координат.
      Ind_max_neg(:, 1) = Pack(Indexes(:, 1), Mask)
      Ind_max_neg(:, 2) = Pack(Indexes(:, 2), Mask)
      
      ! Второй способ: работа сразу с двумя столбцами (требующий размещения в памяти).
      ! 1. Добавляем к маске второй ТАКОЙ ЖЕ столбец:
      ! Two_dim_mask = Spread(Mask_max_neg, 2, 2)).
      ! 2. Запаковываем сразу весь массив индексов по столбцам:
      ! Ind_by_col   = Pack(Ind, Two_dim_mask).
      ! 3. Преобразуем полученный массив в два столбца:
      ! Ind_max_neg  = Reshape(Ind_by_col, [N_max_neg, 2])

      ! Третий способ: работа сразу с двумя столбцами одним оператором:
      !Ind_max_neg = Reshape( Pack(Ind, Spread(Mask_max_neg, 2, 2)), [N_max_neg, 2])
 
      ! Поиск наименьшего из положительных.
      min_pos = MinVal(C, C > 0)
      ! Получаем маску для элементов, равных наименьшему из положительных.
      Mask        = [C == min_pos]
      N_min_pos   = Count(Mask)

      ! Формируем массив индексов, удовлетворяющих заданной маске:

      ! Размещение массивов индексов.
      allocate(Ind_min_pos(N_min_pos, 2))
      ! Упаковка массива индексов по каждой из координат.
      Ind_min_pos(:, 1) = Pack(Indexes(:, 1), Mask)
      Ind_min_pos(:, 2) = Pack(Indexes(:, 2), Mask)
   end subroutine MaxNegAndMinPos
end program exercise_7_19v
