! jagged matrix (array)

type cell
        real, allocatable :: column(:)
end type cell

type(cell), allocatable :: matrix(:)

allocate(matrix(3)) ! матрицу как набор из 3-ёх столбцов

allocate(matrix(1)%column(5)) ! первый столбец имеет длину 5
allocate(matrix(2)%column(3), matrix(3)%column(2)) ! второй столбец имеет длину 3, третий -- два


integer, allocatable, target :: A(:)
integer, pointer :: B(:) => Null()
integer, allocatable, target :: C(:, :)

allocate(B(100)) ! Размещено 100 элементов -- 400 байт

allocate(A(50)) ! Размещено 50 элементов -- 200 байт

...
B => A ! Утечка памяти в 400 байт
B(0:N-1) => A

! Правильно:
deallocate(B)
B => A

B(1:Size(C)) => C ! mapping
! Size(B) == 1000    Size(C) == 1000
! Shape(B) == [1000] Shape(C) == [50, 20]
! rank == 1          rank(C) == 2
! B(1) ~  C(1, 1)
! B(50) ~  C(50, 1)
! B(51) ~ C(1, 2)

