program main
    implicit none

    interface
        subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
            implicit none
            external :: F
            integer, intent(in) :: NEQN
            real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
            integer, intent(inout) :: IFLAG
            real, intent(inout) :: WORK(*)
            integer, intent(inout) :: IWORK(*)
        end subroutine RKF45
    end interface

    EXTERNAL F_SYSTEM
    INTEGER :: NEQN, IFLAG, IWORK(5)
    REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(27)
    REAL :: TPRINT, FINAL, H_ADAMS1, H_ADAMS2, H_CRIT

    ! Количество уравнений
    NEQN = 2

    ! Начальные условия
    T = 0.0
    Y(1) = -3.0
    Y(2) = 0.0

    ! Настройки точности для RKF45
    RELERR = 1.0E-4
    ABSERR = 1.0E-4
    IFLAG = 1

    ! Параметры печати
    TPRINT = 0.05
    FINAL = 1.0

    ! Два фиксированных шага
    H_ADAMS1 = 0.025
    H_ADAMS2 = 0.01

    ! Заголовок
    print *, "===================================================="
    print *, "  Решение системы дифференциальных уравнений"
    print *, "===================================================="
    print *, "dx1/dt = -73x1 - 210x2 + ln(1 + t^2)"
    print *, "dx2/dt = x1 + e^(-t) + t^2 + 1"
    print *, "Начальные условия: x1(0) = -3.0, x2(0) = 0.0"
    print *, "Интервал интегрирования: [0.0, 1.0]"
    print *, "===================================================="

    ! 1. Расчёт критического шага
    H_CRIT = critical_step_adams2()

    ! 2. Решение методом RKF45
    call solve_rkf45()

    ! 3. Метод Адамса с h = 0.025
    print *, ""
    print *, "Метод Адамса 2-го порядка с h =", H_ADAMS1
    call solve_adams(H_ADAMS1)

    ! 4. Метод Адамса с h = 0.01
    print *, ""
    print *, "Метод Адамса 2-го порядка с h =", H_ADAMS2
    call solve_adams(H_ADAMS2)

    ! 5. Метод Адамса с критическим шагом
    print *, ""
    print *, "Метод Адамса 2-го порядка с критическим шагом h =", H_CRIT
    call solve_adams(H_CRIT)

contains

    subroutine solve_rkf45()
        T = 0.0
        Y = [-3.0, 0.0]

        print *, ""
        print *, "Метод RKF45 с EPS =", RELERR
        print *, "----------------------------------------------------"
        print *, "   t         x1(t)              x2(t)"
        print *, "----------------------------------------------------"

        do while (T < FINAL)
            TOUT = min(T + TPRINT, FINAL)
            call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
            if (IFLAG /= 2) then
                print *, "Ошибка в RKF45: IFLAG =", IFLAG
                exit
            endif
            print 100, T, Y(1), Y(2)
        end do
100     format(F8.5, 2X, F15.10, 2X, F15.10)
    end subroutine solve_rkf45

    subroutine solve_adams(h_adams)
        real, intent(in) :: h_adams
        real :: Y_prev(2), Y_curr(2), F_prev(2), F_curr(2)
        real :: t_prev, t_curr, t_print
        integer :: i, steps

        t_prev = 0.0
        Y_prev = [-3.0, 0.0]
        RELERR = 1.0E-6
        ABSERR = 1.0E-6

        print *, "---------------------------------------------------------------"
        print *, "   t         x1(t)                          x2(t)"
        print *, "---------------------------------------------------------------"

        call F_SYSTEM(t_prev, Y_prev, F_prev)
        print 200, t_prev, Y_prev(1), Y_prev(2)

        t_curr = t_prev + h_adams
        Y_curr = Y_prev
        call RKF45(F_SYSTEM, NEQN, Y_curr, t_prev, t_curr, RELERR, ABSERR, IFLAG, WORK, IWORK)
        if (IFLAG /= 2) then
            print *, "Ошибка в RKF45: IFLAG =", IFLAG
            return
        endif
        call F_SYSTEM(t_curr, Y_curr, F_curr)
        print 200, t_curr, Y_curr(1), Y_curr(2)

        steps = floor((FINAL - t_prev)/h_adams)
        t_print = t_curr + TPRINT

        do i = 2, steps
            Y_prev = Y_prev + h_adams * (3.0*F_curr - F_prev)/2.0
            t_prev = t_curr
            t_curr = t_prev + h_adams
            F_prev = F_curr
            call F_SYSTEM(t_curr, Y_prev, F_curr)

            if (t_curr >= t_print - h_adams/2.0 .or. i == steps) then
                print 200, t_curr, Y_prev(1), Y_prev(2)
                t_print = t_print + TPRINT
            end if
            if (t_curr >= FINAL - h_adams/2.0) exit
        end do

        if (abs(t_curr - FINAL) > 1.0E-6) then
            Y_curr = Y_prev
            call RKF45(F_SYSTEM, NEQN, Y_curr, t_curr, FINAL, RELERR, ABSERR, IFLAG, WORK, IWORK)
            if (IFLAG == 2) then
                print 200, FINAL, Y_curr(1), Y_curr(2)
            endif
        end if
200     format(F8.5, 2X, F25.10, 2X, F25.10)
    end subroutine solve_adams

    function critical_step_adams2() result(h_crit)
        real :: h_crit
        real :: A(2,2), trace, det, discr, lambda1, lambda2

        ! 1. Матрица A
        A(1,1) = -73.0
        A(1,2) = -210.0
        A(2,1) = 1.0
        A(2,2) = 0.0

        ! 2. Вычисляем коэффициенты характеристического уравнения
        trace = A(1,1) + A(2,2)
        det = A(1,1)*A(2,2) - A(1,2)*A(2,1)
        discr = trace**2 - 4.0*det

        print *, ""
        print *, "================ Расчёт критического шага =================="
        print *, "Матрица A:"
        print '(2F10.2)', A(1,1), A(1,2)
        print '(2F10.2)', A(2,1), A(2,2)

        ! 3. Характеристическое уравнение: λ^2 + bλ + c = 0
        print *, ""
        print *, "Характеристическое уравнение:"
        print *, "det(A - λI) = 0"
        print *, "λ^2 + ", trace, "*λ +", det, " = 0"

        ! 4. Решение уравнения
        if (discr >= 0.0) then
            lambda1 = 0.5 * (trace + sqrt(discr))
            lambda2 = 0.5 * (trace - sqrt(discr))
            print *, ""
            print *, "Корни уравнения (действительные):"
        else
            lambda1 = 0.5 * trace
            lambda2 = lambda1
            print *, ""
            print *, "Комплексные корни с действительной частью:"
        end if
        print *, "λ1 =", lambda1
        print *, "λ2 =", lambda2

        ! 5. Формула критического шага
        print *, ""
        print *, "Формула критического шага для метода Адамса второго порядка:"
        print *, "h_кр = 1 / max(|λ1|, |λ2|)"

        h_crit = 1.0 / max(abs(lambda1), abs(lambda2))

        ! 6. Вывод критического шага
        print *, ""
        print '(A, F10.6)', "Критический шаг h_кр ≈ ", h_crit
        print *, "============================================================"
    end function critical_step_adams2


end program main

SUBROUTINE F_SYSTEM(T, Y, YP)
    IMPLICIT NONE
    REAL, INTENT(IN) :: T, Y(2)
    REAL, INTENT(OUT) :: YP(2)

    YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
    YP(2) = Y(1) + exp(-T) + T**2 + 1.0
END SUBROUTINE F_SYSTEM
