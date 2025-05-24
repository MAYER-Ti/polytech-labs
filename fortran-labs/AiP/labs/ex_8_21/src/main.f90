! Задание
! Составить процедуру вычисления функции f(x).
! С заданной точностью d=10^(-5)<=|ak|/|f(x)| (ak - очередной член), а затем
! использовать ее при вычислении: q(x) = (f(x) + f(x)*f(x))/(2.75*f(x))
! для 0.1 <= x <= 0.8 с шагом hx = 0.1
! Условия
! Реализация проводится с модулями.
! Все процедуры, предлагаемые для разработки, должны быть чистыми - иметь квалификатор pure. 
! Они не должны использовать встроенные функции по обработке массивов или сечений.
!   8.21 
!   Реализовать чистую элементную функцию f(x).
!   Разница между членами: q(n+1) = x**2 * ((n+0.5)*(n+0.5))/((n+1)*(n+1.5))
!   Члены нумеруются с нуля: n = 0, 1, 2, ...
!   Упростить функцию q(x), сократив на f(x). Реализовать чистую элементную функцию q(x).
!   Формируете массив X и вызываете на нем функцию q(X)
program exercise_8_21
   use Environment
   use MyFunc

   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0
   real(R_), allocatable   :: X(:), res(:)
   real(R_)                :: minValue = 0, maxValue = 0, step = 0 
   
   ! Ввод данных 
   open (file=input_file, newunit=In)
      read (In, *) minValue, maxValue, step 
   close (In)
   ! Размещение X
   call GenDiap(X, minValue, maxValue, step) 

   !Вывод введенных данных 
   open (file=output_file, newunit=Out, position='rewind')
      write(Out, *) "Полученные значения из диапазона, X:"
      write(Out, '('//Size(X)//'f6.2)') X
   close (Out)
   ! Обработка  данных
   allocate(res(Size(X)))
   res = q(X) 

   ! Вывод обработанных данных 
   open (file=output_file, newunit=Out, position='append')
      write(Out, *) "q(X):"
      write(Out, '('//Size(res)//'f6.2)') res
   close (Out)

contains
   pure subroutine GenDiap(Output, minValue, maxValue, step)
      real(R_), allocatable, intent(inout) :: Output(:)
      real(R_), intent(in)                 :: minValue, maxValue, step
      
      integer  :: n, i
      ! Подсчет количества значений 
      n = int((maxValue - minValue)/step) + 1 
      allocate(Output(n))
      ! Запись значений из диапазона 
      Output(1) = minValue
      do concurrent(i = 2:n)
         Output(i) = minValue + real(i-1) * step 
      end do 
   end subroutine GenDiap
end program exercise_8_21
