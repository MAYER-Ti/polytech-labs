! Вариант 25
! Для функции f(x) = cos(x) / (1+x) по узлам xk = 0.2k (k=0,1,..8) построить
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


  ! Вывод результатов
  write (*, '(A15, 9F15.6)') 'Функция:', simple_data
  write (*, '(A15, 9F15.6)') 'Лагранж:', f_interp
  write (*, '(A15, 9F15.6)') 'Сплайн: ', spline_interp
  write (*, '(A35, 9F15.6)') 'Функция - Сплайн:  ', abs(simple_data - spline_interp)
  write (*, '(A35, 9F15.6)') 'Функция - Лагранж: ', abs(simple_data - f_interp)

  ! Вычисление интегралов
  write (*, '(A25)')  'Интеграл (m=-1):  '
  integral_m1 = compute_integral(-1.0, 0.0, 2.1)
  write (*, '(A25)')  'Интеграл (m=-0.5):'
  integral_m05 = compute_integral(0.5, 0.0, 2.1)

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
     real :: res_func = 0.0
     real :: abserr = 0.0, res, errest, nofun, flag

     real, parameter :: relerr(*) = &
         [1.E-00, 1.E-01, 1.E-02, 1.E-03, 1.E-04, 1.E-05, 1.E-06, 1.E-07, 1.E-08, 1.E-09]
     integer :: i = 0 

     m_mod = x

     write (*, '(A15, A10, A15)') "relerr", "flag", "result"
     do i = 1, 10
        call quanc8(integral_func, a, b, abserr, relerr(i), res, errest, nofun, flag)
        if (relerr(i) == 1.E-03) then
            res_func = res 
        end if
        write (*, '(f15.9, f10.3, f15.9)') relerr(i), flag, res
     end do
     compute_integral = res_func

  end function compute_integral
  
end program main

