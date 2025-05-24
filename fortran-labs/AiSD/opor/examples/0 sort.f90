Для каждого J от 1 до N–1
   Для каждого K от J+1 до N
      ??? сколько раз выполняем операцию сравнения
	  
N-1, N-2, ..., 1
S = (a1+an) / 2 * M = (1 + N-1) / 2 * (N-1) = N^2/2 - N/2 ~ O(N^2)

lim (N^2/2 - N/2) / N^2 = C = 1/2

O(N*Log(N)) vs. O(N^2) = O(N*N)
N2 = N*2 ! Число элементов увеличим в два раза

O(2*N*Log(2*N)) vs. O((2*N)^2)
2*O(N*(Log(2)+Log(N))) vs. 4*O(*N^2)
2*O(N*(Log(2)))+2*O(N*Log(N)) vs. 4*O(*N^2)

C*N*Log(N) vs. B*N^2
200*N*Log(N) vs. 10*N^2
N == 10
200*10*Log(10)=2000 vs. 1000
N == 100
200*100*Log(100)=40 000 vs. 100 000

векторизацией?
N == 100
200*100*Log(100)=40 000 vs. 100 000 / 16 (32, 64)

! Сортировка выбором (без обеспечения выровненного сечения)
do i = 1, Size(Neg)-1
         MinInd = MinLoc(Negatives(i:), 1) + i-1
         if (i /= MinInd) then
            tmp               = Negatives(i)
            Negatives(i)      = Negatives(MinInd)
            Negatives(MinInd) = tmp
         end if
end do

! Сортировка выбором с обеспечением выровненного сечения
do i = Size(Neg), 2, -1
         MaxInd = MaxLoc(Negatives(1:i), 1) ! сечение всегда выровнено
         if (i /= MaxInd) then
            tmp               = Negatives(i)
            Negatives(i)      = Negatives(MaxInd)
            Negatives(MaxInd) = tmp
         end if
end do	


* Быстрая сортировка (QuickSort)
* Порязрядная сортировка (Radix Sort)
* Сортировка Шелла
* Сортировка слиянием (Merge Sort)
* Пирамидальная сортировка (Heapsort)
* Сортировка Хора (Hoar Sort)

Отсортировать, используя
сортировку выбором, элементы
главной диагонали двумерного
массива A(5,5).

1) скопировать диагональ, отсортировать в отдельном массиве, вернуть на место
2) 

B(1:Size(A)) => A(:, :) ! pointer rank mapping -- отображение ранга ссылки
! B(1::N+1) -- главная диагональ
С(1:N) => B(1::N+1) ! LBound = 1, UBound = N, inc = N+1, addr
addr(A(1, 1)) == addr(B(1)) == addr(C(1))
addr(A(2, 2)) == addr(B(7)) == addr(C(2))
...
addr(A(5, 5)) == addr(B(25)) == addr(C(5))
call Sort(C) ! процедура Sort не должна требовать непрерывности данных (contiguous)

2*)
B(1:Size(A)) => A
call Sort(B(1::N+1))