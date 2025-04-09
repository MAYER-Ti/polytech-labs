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
    REAL :: TPRINT, FINAL, H_ADAMS1, H_ADAMS2

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

    ! Два шага для метода Адамса
    H_ADAMS1 = 0.025
    H_ADAMS2 = 0.01

    ! Вывод информации о задании
    print *, "===================================================="
    print *, "  Решение системы дифференциальных уравнений"
    print *, "===================================================="
    print *, "Уравнения:"
    print *, "dx1/dt = -73x1 - 210x2 + ln(1 + t^2)"
    print *, "dx2/dt = x1 + e^(-t) + t^2 + 1"
    print *, "Начальные условия:"
    print *, "x1(0) = -3.0, x2(0) = 0.0"
    print *, "Интервал интегрирования: [0.0, 1.0]"
    print *, "===================================================="

    ! 1. Решение методом RKF45
    call solve_rkf45()

    ! 2. Решение методом Адамса с h=0.025
    print *, ""
    print *, "2. Метод Адамса 2-го порядка с h =", H_ADAMS1
    call solve_adams(H_ADAMS1)

    ! 3. Решение методом Адамса с h=0.01
    print *, ""
    print *, "3. Метод Адамса 2-го порядка с h =", H_ADAMS2
    call solve_adams(H_ADAMS2)

contains

    subroutine solve_rkf45()
        ! Решение системы методом RKF45
        T = 0.0
        Y(1) = -3.0
        Y(2) = 0.0

        print *, ""
        print *, "1. Метод RKF45 с EPS =", RELERR
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
        100 format(F8.5, 2X, F15.10, 2X, F15.10)
    end subroutine solve_rkf45

subroutine solve_adams(h_adams)
    ! Решение системы методом Адамса 2-го порядка
    real, intent(in) :: h_adams
    real :: Y_prev(2), Y_curr(2), F_prev(2), F_curr(2)
    real :: t_prev, t_curr, t_print
    integer :: i, steps
    real :: ABSERR, RELERR

    ! Восстановим начальные условия
    t_prev = 0.0
    Y_prev = [-3.0, 0.0]
    ABSERR = 1.0E-6
    RELERR = 1.0E-6

    print *, "---------------------------------------------------------------"
    print *, "   t         x1(t)                          x2(t)"
    print *, "---------------------------------------------------------------"

    ! Первая точка (начальные условия)
    call F_SYSTEM(t_prev, Y_prev, F_prev)
    print 200, t_prev, Y_prev(1), Y_prev(2)

    ! Вторая точка - получаем методом RKF45 с высокой точностью
    t_curr = t_prev + h_adams
    Y_curr = Y_prev
    call RKF45(F_SYSTEM, NEQN, Y_curr, t_prev, t_curr, RELERR, ABSERR, IFLAG, WORK, IWORK)
    if (IFLAG /= 2) then
        print *, "Ошибка в RKF45: IFLAG =", IFLAG
        return
    endif
    call F_SYSTEM(t_curr, Y_curr, F_curr)
    print 200, t_curr, Y_curr(1), Y_curr(2)

    ! Основной цикл метода Адамса
    steps = floor((FINAL - t_prev)/h_adams)  ! Округляем вниз
    t_print = t_curr + TPRINT

    do i = 2, steps
        ! Вычисляем следующее значение по методу Адамса
        Y_prev = Y_prev + h_adams * (3.0*F_curr - F_prev)/2.0
        t_prev = t_curr
        t_curr = t_prev + h_adams

        ! Обновляем производные
        F_prev = F_curr
        call F_SYSTEM(t_curr, Y_prev, F_curr)

        ! Печатаем с фиксированным шагом 0.05
        if (t_curr >= t_print - h_adams/2.0 .or. i == steps) then
            print 200, t_curr, Y_prev(1), Y_prev(2)
            t_print = t_print + TPRINT
        end if

        ! Проверяем, достигли ли конечной точки
        if (t_curr >= FINAL - h_adams/2.0) exit
    end do

    ! Гарантированный вывод конечной точки, если не попали точно в 1.0
    if (abs(t_curr - FINAL) > 1.0E-6) then
        ! Досчитываем последний шаг до t=1.0
        Y_curr = Y_prev
        call RKF45(F_SYSTEM, NEQN, Y_curr, t_curr, FINAL, RELERR, ABSERR, IFLAG, WORK, IWORK)
        if (IFLAG == 2) then
            print 200, FINAL, Y_curr(1), Y_curr(2)
        endif
    endif

    200 format(F8.5, 2X, F25.10, 2X, F25.10)
end subroutine solve_adams

end program main

! Система ОДУ
SUBROUTINE F_SYSTEM(T, Y, YP)
    IMPLICIT NONE
    REAL, INTENT(IN) :: T, Y(2)
    REAL, INTENT(OUT) :: YP(2)

    YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
    YP(2) = Y(1) + exp(-T) + T**2 + 1.0
END SUBROUTINE F_SYSTEM
