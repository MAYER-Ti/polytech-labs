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
    Y(1) = 0.0
    Y(2) = 1.0

    ! Настройки точности для RKF45
    RELERR = 1.0E-4
    ABSERR = 1.0E-4
    IFLAG = 1

    ! Параметры печати
    TPRINT = 0.02
    FINAL = 0.4

    ! Два шага для метода Адамса
    H_ADAMS1 = 0.0020
    H_ADAMS2 = 0.00020

    ! Вывод информации о задании
    print *, "===================================================="
    print *, "  Решение системы дифференциальных уравнений"
    print *, "===================================================="
    print *, "Уравнения:"
    print *, "dx1/dt = -40x1 - 260x2 + 1/(10* t^2 + 1)"
    print *, "dx2/dt = 30x1 + 270x2 + e^(-2t)"
    print *, "Начальные условия:"
    print *, "x1(0) = 0.0, x2(0) = 1.0"
    print *, "Интервал интегрирования: [0.0, 0.4]"
    print *, "===================================================="

    ! 1. Решение методом RKF45
    call solve_rkf45()

    ! 2. Решение методом Адамса с h=0.025
    print *, ""
    print *, "2. Метод Адамса 3-го порядка с h =", H_ADAMS1
    call solve_adams(H_ADAMS1)

    ! 3. Решение методом Адамса с h=0.01
    print *, ""
    print *, "3. Метод Адамса 3-го порядка с h =", H_ADAMS2
    call solve_adams(H_ADAMS2)

contains

    subroutine solve_rkf45()
        ! Решение системы методом RKF45
        T = 0.0
        Y(1) = 0.0
        Y(2) = 1.0

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
        100 format(F8.5, 2X, F20.10, 2X, F20.10)
    end subroutine solve_rkf45

subroutine solve_adams(h_adams)
    ! Решение системы методом Адамса 3-го порядка
    real, intent(in) :: h_adams
    real :: Y0(2), Y1(2), Y2(2), F0(2), F1(2), F2(2)
    real :: t0, t1, t2, t_print
    integer :: i, steps

    ! Восстановим начальные условия
    t0 = 0.0
    Y0 = [0.0, 1.0]
    ABSERR = 1.0E-6
    RELERR = 1.0E-6

    print *, "----------------------------------------------------"
    print *, "   t         x1(t)              x2(t)"
    print *, "----------------------------------------------------"

    ! Первая точка (начальные условия)
    call F_SYSTEM(t0, Y0, F0)
    print 200, t0, Y0(1), Y0(2)

    ! Вторая точка - получаем методом RKF45
    t1 = t0 + h_adams
    Y1 = Y0
    call RKF45(F_SYSTEM, NEQN, Y1, t0, t1, RELERR, ABSERR, IFLAG, WORK, IWORK)
    if (IFLAG /= 2) then
        print *, "Ошибка в RKF45: IFLAG =", IFLAG
        return
    endif
    call F_SYSTEM(t1, Y1, F1)
    print 200, t1, Y1(1), Y1(2)

    ! Третья точка - получаем методом RKF45
    t2 = t1 + h_adams
    Y2 = Y1
    call RKF45(F_SYSTEM, NEQN, Y2, t1, t2, RELERR, ABSERR, IFLAG, WORK, IWORK)
    if (IFLAG /= 2) then
        print *, "Ошибка в RKF45: IFLAG =", IFLAG
        return
    endif
    call F_SYSTEM(t2, Y2, F2)
    print 200, t2, Y2(1), Y2(2)

    ! Основной цикл метода Адамса 3-го порядка
    steps = floor((FINAL - t0)/h_adams) - 2  ! Учитываем уже сделанные 3 шага
    t_print = t2 + TPRINT

    do i = 3, steps
        ! Вычисляем следующее значение по методу Адамса 3-го порядка
        Y0 = Y2 + h_adams*(23.0*F2 - 16.0*F1 + 5.0*F0)/12.0
        t0 = t2 + h_adams

        ! Обновляем производные
        F0 = F1
        F1 = F2
        call F_SYSTEM(t0, Y0, F2)

        ! Обновляем значения для следующего шага
        Y2 = Y0
        t2 = t0

        ! Печатаем с фиксированным шагом 0.05
        if (t2 >= t_print - h_adams/2.0 .or. i == steps) then
            print 200, t2, Y2(1), Y2(2)
            t_print = t_print + TPRINT
        end if

        ! Проверяем, достигли ли конечной точки
        if (t2 >= FINAL - h_adams/2.0) exit
    end do

    ! Гарантированный вывод конечной точки, если не попали точно в 1.0
    if (abs(t2 - FINAL) > 1.0E-6) then
        ! Досчитываем последний шаг до t=1.0
        Y0 = Y2
        call RKF45(F_SYSTEM, NEQN, Y0, t2, FINAL, RELERR, ABSERR, IFLAG, WORK, IWORK)
        if (IFLAG == 2) then
            print 200, FINAL, Y0(1), Y0(2)
        endif
    endif

    200 format(F8.5, 2X, F20.10, 2X, F20.10)
end subroutine solve_adams

end program main

! Система ОДУ
SUBROUTINE F_SYSTEM(T, Y, YP)
    IMPLICIT NONE
    REAL, INTENT(IN) :: T, Y(2)
    REAL, INTENT(OUT) :: YP(2)

    YP(1) = -40.0 * Y(1) + 260.0 * Y(2) + 1.0 / (10.0 * T**2 + 1.0)
    YP(2) = 30 * Y(1) - 270 * Y(2) + exp(-2 * T)
END SUBROUTINE F_SYSTEM
