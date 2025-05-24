! ex_6_2v
! Вычислить сумму членов рядов, представляющих занчения следующих функций (суммирование
! производить до тех пор, пока отношение текущего члена ряда к накопленной сумме
! не станет меньше заданной величины RELERR):
! в) ln(x+a) = ln(x) + 2[ (a/(a*x+a)) + ((a**3)/(3*(2*x+a))) + ((a**5)/(5*(2*x+a))) + ...]
! Указания
! Проводить вычисления, пока сумма не перестанет меняться (см. решение примера). 
! Очередной член (или очередной числитель и знаменатель) вычислять относительно предыдущего. 
! Если возможно, то разницу между членами вычислять один раз до цикла (например x2). 
! В некоторых случаях шаг цикла удобно делать равным 2 
! (например, если требуются только факториалы чётных чисел). 
!Начальные значения переменным давать до цикла. Сравнить результат со встроенной функцией.
! Меняя разновидность вещественного типа на двойную и четверную точность, 
!посмотреть, сколько членов ряда потребуется для сходимости.
program exercise_6_2v
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0
   real(R_)                :: ln_x_a = 0, x = 0, a = 0

   open (file=input_file, newunit=In)
      read (In, *) x,a 
   close (In)
   
   ln_x_a = Ln_x_plus_a(x, a)

   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '(4(a, T16, "= ", e13.6/))') 'x', x, "ln(x+a)", ln_x_a, "Fortran ln(x+a)", log(x+a), "Error", ln_x_a - log(x+a)
   close (Out)

contains
   ! Чистая функция в императивном стиле.
   !
   real(R_) pure function Ln_x_plus_a(x, a) result(LnXA)
      real(R_), intent(in) :: x, a 
      ! 2pi == 2 * 4*Arctg(1), т. к. Tg(1) = pi/4 => pi == 4*Arctg(1)
      ! real(R_), parameter :: double_PI = 8 * Atan(1._R_)
      real(R_)    r, q, a_2, znam_2, OldSum, CurSum
      integer     n

      ! Делим x по модулю 2*pi, т. к. Sin(2*pi*n+a) = Sin(a).
      !x_s = Mod(x, double_PI)
      
      !Чтобы не вычислять каждый раз
      a_2         = a**2
      znam_2 = (2*x+a)**2
      
      n       = 1
      r       = a/(2*x+a)
      CurSum  = r 
      
      ! Цикл с постусловием: пока сумма не перестанет меняться.
      do
         n       = n + 2
         q       = a_2 / (n*znam_2)
         r       = r * q
         OldSum  = CurSum
         CurSum  = CurSum + r 
         if (OldSum == CurSum) exit
      end do

     !write(*,*) "oldsum - ", OldSum, " CurSum - ", CurSum
      LnXA = log(x) + 2 * CurSum

      !print "('Число членов суммы: ', i0)", n / 2 + 1
      !print "('Число итераций: ', i0)", n / 2
   end function Ln_x_plus_a
end program exercise_6_2v
