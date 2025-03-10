! Вариант 14
! Для 1 <= x <= 4 с h = 0.375 вычислить значения f(x) = integ(0,20){ (dz)/(e^(z)*z+x) }
! Используя для вычисления интеграла программу QUANC8. По полученным точкам простроить
! сплайн-функцию и полином Лагранжа 8-й степени. Сравнить значения 
! обеих аппроксимаций в точках x(k)=1.1875+0.375k (k=0,1,..,7)
!
program matrix_analysis
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

    real    :: a, b, relerr, abserr, res, errest, flag
    integer :: nofun
    real, allocatable :: x_values(:), f_values(:)
    real, allocatable :: b_coef(:), c_coef(:), d_coef(:)
    integer :: i, k, x_n
    real    :: xk, spline_val, lagrange_val

    external quanc8
    ! Установка параметров интегрирования
    a = 0.0
    b = 20.0
    relerr = 1.E-06
    abserr = 0.0
    h = 0.375
    x = 1.0
    x_n = 1

    DO WHILE (x <= 4) 
        x = x + h
        x_n = x_n + 1
    END DO 
    x = 1.0

    ALLOCATE(x_values(x_n), f_values(x_n), b_coef(x_n), c_coef(x_n), d_coef(x_n))

    i = 1
    ! Вычисление значений функции f(x) для 1 <= x <= 4 с шагом h
    DO WHILE (x <= 4.0)
        CALL quanc8(integral_func, a, b, abserr, relerr, res, errest, nofun, flag)
        x_values(i) = x
        f_values(i) = res
        print *, x_values(i), f_values(i)

        x = x + h
        i = i + 1
    END DO

    ! Вызов подпрограммы SPLINE для вычисления коэффициентов сплайна
    CALL SPLINE(x_n, x_values, f_values, b_coef, c_coef, d_coef)

    ! Сравнение значений в точках xk = 1.1875 + 0.375k (k=0,1,...,7)
    WRITE(*, '(A10, A15, A15)') 'xk', 'spline(xk)', 'lagrange(xk)'
    DO k = 0, 7
        xk = 1.1875 + 0.375 * k
        ! Вычисление значений сплайна и полинома Лагранжа в точке xk
        spline_val = SEVAL(x_n, xk, x_values, f_values, b_coef, c_coef, d_coef)
        lagrange_val = compute_lagrange(xk, x_values, f_values)
        WRITE(*, '(F10.4, F15.6, F15.6)') xk, spline_val, lagrange_val
    END DO

    DEALLOCATE(x_values, f_values, b_coef, c_coef, d_coef)

contains

    REAL FUNCTION compute_lagrange(x, x_values, f_values) RESULT(lagrange_val)
        REAL, INTENT(IN) :: x, x_values(:), f_values(:)
        INTEGER :: n, i, j
        REAL :: term, prod

        n = SIZE(x_values)
        lagrange_val = 0.0

        DO i = 1, n
            term = f_values(i)
            prod = 1.0
            DO j = 1, n
                IF (j /= i) THEN
                    prod = prod * (x - x_values(j)) / (x_values(i) - x_values(j))
                END IF
            END DO
            lagrange_val = lagrange_val + term * prod
        END DO
    END FUNCTION compute_lagrange

  end program matrix_analysis

