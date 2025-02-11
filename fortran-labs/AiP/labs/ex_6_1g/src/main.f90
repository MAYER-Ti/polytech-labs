! Задание
! Вычислить с заданной абсолютной погрешностью ABSERR значения элементарных функций при заданном занчении аргумента x:
! г) arcsin(x) = x + (x**3)/(2*3) + ((1*3)*(x**5))/(2*4*5) + ((1*3*5)*(x**7))/(2*4*6*7) + ...
! |x| < 1
! Указания:
! Проводить вычисления, пока сумма не перестанет меняться (см. решение примера). Очередной член (или очередной числитель и знаменатель) вычислять относительно предыдущего. Если возможно, то разницу между членами вычислять один раз до цикла (например x2). В некоторых случаях шаг цикла удобно делать равным 2 (например, если требуются только факториалы чётных чисел). Начальные значения переменным давать до цикла. Сравнить результат со встроенной функцией. Меняя разновидность вещественного типа на двойную и четверную точность, посмотреть, сколько членов ряда потребуется для сходимости

! Ряд Тейлора
! arcsin x = x + (x^3)/6 + (3*(x^5))/40 + ... = (n = 0)(><)сумм( ((2*n)! / ( 4^n * (n!)^2 * (2n+1) )) * x^(2n+1)   )
! 

program ex_6_1g
   use Environment
   
   implicit none
   character(*), parameter :: input_file = "../data/input.txt", output_file = "output.txt"
   integer                 :: In = 0, Out = 0
   real(R_)                :: Asin_x = 0, x = 0
   
   !Ввод данных
   open (file=input_file, newunit=In)
      read (In, *) x
   close (In)

   !Обработка данных 
   !sin_x = SinXImp(x)
   Asin_x = Asin_Imp(x)

   ! Вывод обработанных данных
   open (file=output_file, encoding=E_, newunit=Out)
      write (Out, '(4(a, T16, "= ", e13.6/))') 'x', x, "Asin(x)", Asin_x, "Fortran Asin(x)", Asin(x), "Error", Asin_x - Asin(x)
   close (Out)

contains
   real(R_) elemental function ASin_Imp(x) result(ASinX)
      real(R_), intent(in) :: x
      
      real(R_)    r, q, x_2, OldASinX
      integer     n

      ! Чтобы не вычислять каждый раз.
      x_2   = x * x
      
      n     = 0
      r     = x 
      ASinX  = r

      ! Цикл с постусловием: пока сумма не перестанет меняться.
      do
         q        = x_2 * ((n + 0.5)*(n + 0.5))/((n+1)*(n+1.5))
         n        = n + 1
         r        = r * q
         OldASinX  = ASinx
         ASinX     = ASinX + r
         if (OldASinX == ASinx) exit
      end do
      !print "('Число членов суммы: ', i0)", n / 2 + 1
      !print "('Число итераций: ', i0)", n / 2
       
   end function ASin_Imp
!   real(R_) elemental  function ASin_(x) result(AsinX)
!   ! Чистая функция в регулярном стиле real(R_) pure function AsinX(x)
!      real(R_), intent(in) :: x
!      
!      ! 2pi == 2 * 4*Arctg(1), т. к. Tg(1) = pi/4 => pi == 4*Arctg(1)
!      real(R_), parameter :: double_PI = 8 * Atan(1._R_)
!      ! Относительная погрешность вычислений.
!      real(R_) R(4), Numerators(4), Denominators(4)
!      integer  Ns(8)
!      ! Получение суммы СРАЗУ первых 4-ёх членов (со 2-ого по 5-ый),
!      ! а затем в цикле расчитываем СРАЗУ по 4 члена за итерацию.
!
!      ! 1. Вычисление числителей: 
!      !    x^(2n+1):x^3, x^5, x^7, x^9
!      Numerators = x_s ** [3, 5, 7, 9]
!      ! Вычисление x^8 для будущих вычислений числителей (получаем из x^9) 
!      x_8 = Numerators(4) / x_s
!      !    x^(2n+1) * (2n)!:  4! 6! 8! 10!  
!      num_fact = 2*3*4*5*6*7*8*9*10
!      den_fact = 2*3*4*5*6
!      Numerators = Numerators * [2*3*4, Int(den_fact), Int(num_fact)/9/10, Int(num_fact)]
!      ! Вычисление 6! для дальнейшего использования в цикле
!      ! 2. Вычисление Знаменателей:
!      ! (n!): 2!, 3!, 4!, 5!
!      Denominators = [2, 2*3, 2*3*4, Int(den_fact)/6]
!      ! (n!)^2 
!      Denominators = Denominators ** 2 
!      ! (n!)^2 * 4^n: 4^2, 4^3, 4^4, 4^5    
!      Denominators = Denominators * [16, 16**2, 16**3, 16**4]
!      ! (n!)^2 * 4^n * (2n+1)
!      Denominators = Denominators * [3, 5, 7, 9] 
!      ! Вычисление всех необходимых множителей для этих знаменателей.
!      ! Будет использовано при вычислении очередных 4-ёх знаменателей.
!      !Ns = [2, 4, 6, 8, 3, 5, 7, 9]
!      Ns = [2, 3, 4, 5, 6, 7, 8, 9]
!      ! 3. Вычисление суммы членов со 2-ого по 5-ый.
!      R = Numerators / Denominators ! ВЕКТОРИЗАЦИЯ
!      ! 4. Сумма первых 5-ти членов.
!      AsinX = x_s + Sum(R)
!      
!      ! Цикл с постусловием: пока сумма не перестанет меняться из-за последнего члена.
!      ! На каждой итерации цикла проводится вычисление СРАЗУ 4-ёх членов суммы. 
!      do while (AsinX + R(4) /= AsinX)
!         ! 1   x^3     1*3    x^5     1*3*5   x^7 
!         ! - * ---  +  ---  * ---  +  ----- * --- + ... 
!         ! 2    3      2*4     5      2*4*6    7 
!         ! Получение СРАЗУ 4-ёх очередных членов суммы.
!         ! 2. Вычисление очередных знаменателей-факториалов: n!
!         !     1) Запись накопленного факториала для будущих вычислений знаменателей.
!         !        Например, на первой итерации dec_fact == 6!.
!         den_facts(1) = den_fact
!         den_facts(2) = den_facts(1) * Ns(6)
!         den_facts(3) = den_facts(2) * Ns(7)
!         den_facts(4) = den_facts(3) * Ns(8)   
!         den_fact = den_facts(4)  
!         ! n! 
!         Denominators = den_facts
!
!         ! (n!)^2
!         Denominators = Denominators ** 2 
!         ! (n!)^2 * 4^n 
!         Denominators = Denominators * 4**(Ns(5:8))
!         ! (n!)^2 * 4^n * (2n+1)
!         Denominators = Denominators * (2*Ns(5:8)+1) 
!
!         ! 1. Вычисление очередных 4-ёх числителей.  
!         ! Например, на первой итерации Numerators == [4!*x^3, 6!*(x^5), 8!*(x^7), 10!*(x^9)] и,
!         ! умножая его на x^8, получаем следующие числители [4!*x^11, 6!*x^13, 8!*x^15, 10!*x^17]. 
!         Numerators = Numerators * x_8
!
!         ! 2. Вычисление очередных факториалов в числителе
!         ! Например на первой итерации Numerators == [4!*x^3, 6!*(x^5), 8!*(x^7), 10!*(x^9)] и,
!         !   [12!*x^3, 14!*(x^5), 16!*(x^7), 18!*(x^9)]
!         ! При первой итерпции цикла num_fact = 10! 
!         ! Ns = [10, 11, 12, 13, 14, 15, 16, 17]
!         Ns = Ns + 8 
!         ! Вычисление факториала числителя 
!         ! num 1      = 10!           * 11    * 12 
!         num_facts(1) = num_fact      * Ns(2) * Ns(3)
!         ! num 2      = 12!          * 13    * 14
!         num_facts(2) = num_facts(1) * Ns(4) * Ns(5) 
!         ! num 3      = 14!          * 15    * 16
!         num_facts(3) = num_facts(2) * Ns(6) * Ns(7) 
!         ! num 4      = 16!          * 17    * 18
!         num_facts(4) = num_facts(3) * Ns(8) * (Ns(8)+1)    
!         ! Добавление факториала к числителю
!         Numerators = Numerators * num_facts
!         ! Запись последнего факториала для следующей итерации
!         num_fact = num_facts(4)
!        ! Ns = Ns + 1
!        ! num_facts = num_facts * Ns(1:4) * Ns(5:8)
!        ! Ns = Ns - 1
!        ! Numerators(1) = num_facts(1)
!        ! do i = 2,4
!        !    Numerators(i) = num_facts(i)
!        ! end do
!         
!         ! 3. Вычисление очередных 4-ёх членов суммы.
!         R = Numerators / Denominators
!         ! Прибавление очередных 4-ёх членов к накапливаемой сумме.
!         AsinX = AsinX + Sum(R)
!      end do
!      !print "('Число членов суммы: ', i0)", (Ns(8)+1) / 2
!      !print "('Число итераций: ', i0)", (Ns(8)-1) / 8
!   end function Asin_  
end program ex_6_1g
