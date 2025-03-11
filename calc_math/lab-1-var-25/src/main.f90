! Вариант 25
! Для функции f(x) = cos(x) / (1+x) по ущлам xk = 0.2k (k=0,1,..8) построить
! полином Лагранжа L(x) 8-й степени и сплайн-функцию S(x). Вычислить значения
! всех трех функций в точках yk = 0.1 + 0.2k (k=0,1,..7). Построить графики.
! Используя программу QUANC8 вычислить два интеграла:
! от 0 до 2.1 (abs(x^2+2*x-3))^m dx, для m = -1 и для m = -0.5
!
program main
  use integral_func_mod
  implicit none

    interface
        subroutine SPLINE(N, X, Y, B, C, D) 
            integer, intent(in) :: N ! Число заданных точек или узлов
            real, intent(in)    :: X(N) ! Абсциссы узлов в строго возрастающем порядке
            real, intent(in)    :: Y(N) ! Ординаты узлов
            real, intent(out)   :: B(N), C(N), D(N) ! Массивы определенных выше коэффициентов сплайна
        end subroutine SPLINE
    
        function SEVAL(N, Xi, X, Y, B, C, D) result(seval_value) 
            integer, intent(in) :: N 
            real, intent(in)    :: Xi, X(N), Y(N), B(N), C(N), D(N) 
            real                :: seval_value
        end function SEVAL 

    end interface

    external quanc8

  integer, parameter :: n = 9, m = 8
  integer :: k = 0
  real :: x_values(n), f_values(n)
  real :: y_values(m), f_interp(m), spline_interp(m), simple_data(m)
  real :: integral_m1, integral_m05

  ! Задание узлов интерполяции
  do k = 0, n-1
     x_values(k+1) = 0.2 * k
     f_values(k+1) = func(x_values(k+1))
  end do

  ! Задание точек для вычислений
  do k = 0, m-1
     y_values(k+1) = 0.1 + 0.2 * k
  end do

  ! Простое вычисление функции
  call simple_calc(m, y_values, simple_data)

  ! Интерполяция методом Лагранжа
  call lagrange_interpolation(n, x_values, f_values, m, y_values, f_interp)

  ! Сплайн-интерполяция
  call spline_interpolation(n, x_values, f_values, m, y_values, spline_interp)

  ! Вычисление интегралов
  integral_m1 = compute_integral(-1.0, 0.0, 21.0)
  integral_m05 = compute_integral(5.0, 0.0, 21.0)

  ! Вывод результатов
  print *, 'Функция:', simple_data
  print *, 'Лагранж:', f_interp
  print *, 'Сплайн: ', spline_interp
  print *, 'Интеграл (m=-1):', integral_m1
  print *, 'Интеграл (m=-0.5):', integral_m05

contains

  subroutine lagrange_interpolation(n, x, f, m, y, f_interp)
    integer, intent(in) :: n, m
    real, intent(in) :: x(n), f(n)
    real, intent(in) :: y(m) 
    real, intent(inout) :: f_interp(m)
    integer :: i, j, k
    real :: L
    do i = 1, m
       f_interp(i) = 0.0d0
       do j = 1, n
          L = 1.0d0
          do k = 1, n
             if (k /= j) then
                L = L * (y(i) - x(k)) / (x(j) - x(k))
             end if
          end do
          f_interp(i) = f_interp(i) + L * f(j)
       end do
    end do
  end subroutine lagrange_interpolation

  subroutine spline_interpolation(n, x, f, m, y, spline_interp)
    integer, intent(in) :: n, m
    real, intent(in) :: x(n), f(n)
    real, intent(in) :: y(m)
    real, intent(out) :: spline_interp(m)
    real :: b_coef(n), c_coef(n), d_coef(n)
    integer :: i
    call SPLINE(n, x, f, b_coef, c_coef, d_coef)
    ! Значения сплайна
    do i = 1, m 
       spline_interp(i) = SEVAL(n, y(i), x, f, b_coef, c_coef, d_coef)
    end do
  end subroutine spline_interpolation

  subroutine simple_calc(m, y, values)
      integer, intent(in) :: m
      real, intent(in) :: y(m)
      real, intent(out) :: values(m)
      integer :: i = 0 
      do i = 1, m 
         values(i) = func(y(i))
      end do

  end subroutine simple_calc

  real function func(x)
      real, intent(in) :: x 
      func = cos(x) / (1.0 + x)
  end function func

  real function compute_integral(x, a, b)
     real, intent(in) :: x 
     real, intent(in) :: a, b 

     real :: abserr = 0.0, relerr = 1.E-06, res, errest, nofun, flag

     m_mod = x
     call quanc8(integral_func, a, b, abserr, relerr, res, errest, nofun, flag)
     compute_integral = res

  end function compute_integral
  
end program main

