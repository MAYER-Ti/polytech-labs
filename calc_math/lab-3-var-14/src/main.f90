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
    REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
    REAL :: TPRINT, FINAL, H_ADAMS1, H_ADAMS2

    ! Количество уравнений
    NEQN = 2

    ! Начальные условия
    T = 0.0
    Y(1) = -3.0
    Y(2) = 0.0  ! x2(0) = t при t=0 => 0

    ! Настройки точности для RKF45
    RELERR = 1.0E-4  ! EPS=0.0001
    ABSERR = 1.0E-4
    IFLAG = 1

    ! Параметры печати
    TPRINT = 0.05
    FINAL = 1.0  ! Интервал [0,1]
    
    ! Два шага для метода Адамса
    H_ADAMS1 = 0.025  ! Первый шаг (по заданию)
    H_ADAMS2 = 0.01   ! Второй шаг (меньше для лучшей точности)

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
    
    ! 1. Решение методом RKF45 с EPS=0.0001
    call solve_rkf45()
    
    ! 2. Решение методом Адамса с h=0.025
    print *, ""
    print *, "2. Метод Адамса 2-го порядка с h =", H_ADAMS1
    call solve_adams(H_ADAMS1)
    
    ! 3. Решение методом Адамса с h=0.01 (второй шаг)
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
            print 100, T, Y(1), Y(2)
        end do
        100 format(F7.4, 3X, F14.8, 3X, F14.8)
    end subroutine solve_rkf45

    subroutine solve_adams(h_adams)
        ! Решение системы методом Адамса 2-го порядка
        real, intent(in) :: h_adams
        real :: Y_prev(2), F_prev(2), F_curr(2)
        real :: t_prev
        integer :: i, steps, print_step
        
        ! Восстановим начальные условия
        T = 0.0
        Y(1) = -3.0
        Y(2) = 0.0
        
        print *, "----------------------------------------------------"
        print *, "   t         x1(t)              x2(t)"
        print *, "----------------------------------------------------"
        
        ! Первая точка (начальные условия)
        call F_SYSTEM(T, Y, F_prev)
        print 200, T, Y(1), Y(2)
        
        ! Вторая точка - получаем методом RKF45
        TOUT = T + h_adams
        call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
        call F_SYSTEM(T, Y, F_curr)
        print 200, T, Y(1), Y(2)
        
        ! Сохраняем предыдущие значения
        Y_prev = Y
        t_prev = T
        
        ! Основной цикл метода Адамса
        steps = nint((FINAL - T)/h_adams) - 1
        print_step = nint(TPRINT/h_adams)
        
        do i = 2, steps
            ! Формула Адамса 2-го порядка: Zn+1 = Zn + h(3fn - fn-1)/2
            Y = Y_prev + h_adams * (3.0*F_curr - F_prev)/2.0
            T = t_prev + h_adams
            
            ! Обновляем предыдущие значения
            Y_prev = Y
            t_prev = T
            F_prev = F_curr
            call F_SYSTEM(T, Y, F_curr)
            
            ! Печатаем с шагом TPRINT
            if (mod(i, print_step) == 0 .or. T >= FINAL) then
                print 200, T, Y(1), Y(2)
            end if
        end do
        200 format(F7.4, 3X, F14.8, 3X, F14.8)
    end subroutine solve_adams

end program main 

! Система ОДУ
SUBROUTINE F_SYSTEM(T, Y, YP)
    IMPLICIT NONE
    REAL, INTENT(IN) :: T, Y(2)
    REAL, INTENT(OUT) :: YP(2)

    YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
    YP(2) = Y(1) + exp(-T) + T**2 + 1.0  ! Согласно уточненному заданию
END SUBROUTINE F_SYSTEM
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, H_ADAMS1, H_ADAMS2
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = 0.0  ! x2(0) = t при t=0 => 0
! 
!     ! Настройки точности для RKF45
!     RELERR = 1.0E-4  ! EPS=0.0001
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати
!     TPRINT = 0.05
!     FINAL = 1.0  ! Интервал [0,1]
! 
!     ! Два шага для метода Адамса
!     H_ADAMS1 = 0.025  ! Первый шаг (по заданию)
!     H_ADAMS2 = 0.01   ! Второй шаг (меньше для лучшей точности)
! 
!     ! Вывод информации о задании
!     print *, "============================================"
!     print *, "  Решение системы дифференциальных уравнений"
!     print *, "============================================"
!     print *, "Уравнения:"
!     print *, "dx1/dt = -73x1 - 210x2 + ln(1 + t^2)"
!     print *, "dx2/dt = x1 + e^(-t) + t^2 + 1"
!     print *, "Начальные условия:"
!     print *, "x1(0) = -3, x2(0) = 0"
!     print *, "Интервал интегрирования: [0, 1]"
!     print *, "============================================"
! 
!     ! 1. Решение методом RKF45 с EPS=0.0001
!     call solve_rkf45()
! 
!     ! 2. Решение методом Адамса с h=0.025
!     print *, ""
!     print *, "Метод Адамса с h =", H_ADAMS1
!     call solve_adams(H_ADAMS1)
! 
!     ! 3. Решение методом Адамса с h=0.01 (второй шаг)
!     print *, ""
!     print *, "Метод Адамса с h =", H_ADAMS2
!     call solve_adams(H_ADAMS2)
! 
! contains
! 
!     subroutine solve_rkf45()
!         ! Решение системы методом RKF45
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
! 
!         print *, ""
!         print *, "1. Метод RKF45 с EPS =", RELERR
!         print *, "--------------------------------------------"
!         print *, "   t        x1(t)            x2(t)"
!         print *, "--------------------------------------------"
! 
!         do while (T < FINAL)
!             TOUT = min(T + TPRINT, FINAL)
!             call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             print 100, T, Y(1), Y(2)
!         end do
!         100 format(F6.3, 2X, F12.6, 2X, F12.6)
!     end subroutine solve_rkf45
! 
!     subroutine solve_adams(h_adams)
!         ! Решение системы методом Адамса 2-го порядка
!         real, intent(in) :: h_adams
!         real :: Y_prev(2), F_prev(2), F_curr(2)
!         real :: t_prev
!         integer :: i, steps, print_step
! 
!         ! Восстановим начальные условия
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
! 
!         print *, "--------------------------------------------"
!         print *, "   t        x1(t)            x2(t)"
!         print *, "--------------------------------------------"
! 
!         ! Первая точка (начальные условия)
!         call F_SYSTEM(T, Y, F_prev)
!         print 100, T, Y(1), Y(2)
! 
!         ! Вторая точка - получаем методом RKF45
!         TOUT = T + h_adams
!         call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!         call F_SYSTEM(T, Y, F_curr)
!         print 100, T, Y(1), Y(2)
! 
!         ! Сохраняем предыдущие значения
!         Y_prev = Y
!         t_prev = T
! 
!         ! Основной цикл метода Адамса
!         steps = nint((FINAL - T)/h_adams) - 1
!         print_step = nint(TPRINT/h_adams)
! 
!         do i = 2, steps
!             ! Формула Адамса 2-го порядка: Zn+1 = Zn + h(3fn - fn-1)/2
!             Y = Y_prev + h_adams * (3.0*F_curr - F_prev)/2.0
!             T = t_prev + h_adams
! 
!             ! Обновляем предыдущие значения
!             Y_prev = Y
!             t_prev = T
!             F_prev = F_curr
!             call F_SYSTEM(T, Y, F_curr)
! 
!             ! Печатаем с шагом TPRINT
!             if (mod(i, print_step) == 0 .or. T >= FINAL) then
!                 print 100, T, Y(1), Y(2)
!             end if
!         end do
!         100 format(F6.3, 2X, F12.6, 2X, F12.6)
!     end subroutine solve_adams
! 
! end program main
! 
! ! Система ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
!     YP(2) = Y(1) + exp(-T) + T**2 + 1.0  ! Согласно уточненному заданию
! END SUBROUTINE F_SYSTEM
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, H_ADAMS
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = 0.0  ! x2(0) = t при t=0 => 0
! 
!     ! Настройки точности
!     RELERR = 1.0E-4
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати
!     TPRINT = 0.05
!     FINAL = 1.0  ! Интервал [0,1]
!     H_ADAMS = 0.025  ! Шаг интегрирования для Адамса
! 
!     ! Вывод заголовка
!     print *, "============================================"
!     print *, "  Решение системы дифференциальных уравнений"
!     print *, "============================================"
!     print *, "Метод 1: RKF45 (Рунге-Кутта-Фельберга 4-5 порядка)"
!     print *, "Метод 2: Адамса 2-го порядка с h =", H_ADAMS
!     print *, "Шаг печати результатов:", TPRINT
!     print *, "Относительная погрешность:", RELERR
!     print *, "Абсолютная погрешность:", ABSERR
!     print *, "============================================"
! 
!     ! Решение методом RKF45
!     call solve_rkf45()
! 
!     ! Решение методом Адамса
!     call solve_adams()
! 
! contains
! 
!     subroutine solve_rkf45()
!         ! Решение системы методом RKF45
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
! 
!         print *, ""
!         print *, "Метод RKF45:"
!         print *, "--------------------------------------------"
!         print *, "   t        x1(t)            x2(t)"
!         print *, "--------------------------------------------"
! 
!         do while (T < FINAL)
!             TOUT = min(T + TPRINT, FINAL)
!             call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             print 100, T, Y(1), Y(2)
!         end do
!         100 format(F6.3, 2X, F12.6, 2X, F12.6)
!     end subroutine solve_rkf45
! 
!     subroutine solve_adams()
!         ! Решение системы методом Адамса 2-го порядка
!         real :: Y_prev(2), F_prev(2), F_curr(2)
!         real :: t_prev
!         integer :: i, steps, print_step
! 
!         print *, ""
!         print *, "Метод Адамса 2-го порядка:"
!         print *, "--------------------------------------------"
!         print *, "   t        x1(t)            x2(t)"
!         print *, "--------------------------------------------"
! 
!         ! Первая точка (начальные условия)
!         call F_SYSTEM(T, Y, F_prev)
!         print 100, T, Y(1), Y(2)
! 
!         ! Вторая точка - получаем методом RKF45
!         TOUT = T + H_ADAMS
!         call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!         call F_SYSTEM(T, Y, F_curr)
!         print 100, T, Y(1), Y(2)
! 
!         ! Сохраняем предыдущие значения
!         Y_prev = Y
!         t_prev = T
! 
!         ! Основной цикл метода Адамса
!         steps = nint((FINAL - T)/H_ADAMS) - 1
!         print_step = nint(TPRINT/H_ADAMS)
! 
!         do i = 2, steps
!             ! Вычисляем следующее значение по методу Адамса
!             Y = Y_prev + H_ADAMS * (3.0*F_curr - F_prev)/2.0
!             T = t_prev + H_ADAMS
! 
!             ! Обновляем предыдущие значения
!             Y_prev = Y
!             t_prev = T
!             F_prev = F_curr
!             call F_SYSTEM(T, Y, F_curr)
! 
!             ! Печатаем с шагом TPRINT
!             if (mod(i, print_step) == 0) then
!                 print 100, T, Y(1), Y(2)
!             end if
!         end do
!         100 format(F6.3, 2X, F12.6, 2X, F12.6)
!     end subroutine solve_adams
! 
! end program main
! 
! ! Система ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
!     YP(2) = Y(1) + exp(-T) + T**2 + 1.0  
! END SUBROUTINE F_SYSTEM
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, H_ADAMS
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = 0.0  ! x2(0) = t при t=0 => 0
! 
!     ! Настройки точности
!     RELERR = 1.0E-4
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати
!     TPRINT = 0.05
!     FINAL = 1.0  ! Интервал [0,1]
!     H_ADAMS = 0.025  ! Шаг интегрирования для Адамса
! 
!     ! Решение методом RKF45
!     call solve_rkf45()
!     
!     ! Решение методом Адамса
!     call solve_adams()
!     
! contains
! 
!     subroutine solve_rkf45()
!         ! Решение системы методом RKF45
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
!         
!         print *, "Solution by RKF45 method:"
!         print *, "t", "x1", "x2"
!         
!         do while (T < FINAL)
!             TOUT = min(T + TPRINT, FINAL)
!             call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             print *, T, Y(1), Y(2)
!         end do
!     end subroutine solve_rkf45
! 
!     subroutine solve_adams()
!         ! Решение системы методом Адамса 2-го порядка
!         real :: Y_prev(2), F_prev(2), F_curr(2)
!         real :: t_prev
!         integer :: i, steps, print_step
!         
!         print *, "Solution by Adams method (h=0.025):"
!         print *, "t", "x1", "x2"
!         
!         ! Первая точка (начальные условия)
!         call F_SYSTEM(T, Y, F_prev)
!         print *, T, Y(1), Y(2)
!         
!         ! Вторая точка - получаем методом RKF45
!         TOUT = T + H_ADAMS
!         call RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!         call F_SYSTEM(T, Y, F_curr)
!         print *, T, Y(1), Y(2)
!         
!         ! Сохраняем предыдущие значения
!         Y_prev = Y
!         t_prev = T
!         
!         ! Основной цикл метода Адамса
!         steps = nint((FINAL - T)/H_ADAMS) - 1
!         print_step = nint(TPRINT/H_ADAMS)
!         
!         do i = 2, steps
!             ! Вычисляем следующее значение по методу Адамса
!             Y = Y_prev + H_ADAMS * (3.0*F_curr - F_prev)/2.0
!             T = t_prev + H_ADAMS
!             
!             ! Обновляем предыдущие значения
!             Y_prev = Y
!             t_prev = T
!             F_prev = F_curr
!             call F_SYSTEM(T, Y, F_curr)
!             
!             ! Печатаем с шагом TPRINT
!             if (mod(i, print_step) == 0) then
!                 print *, T, Y(1), Y(2)
!             end if
!         end do
!     end subroutine solve_adams
! 
! end program main 
! 
! ! Система ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + log(1.0 + T**2)
!     YP(2) = Y(1) + exp(-T) + T**2 + 1
! END SUBROUTINE F_SYSTEM
! ! Вариант 14
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, HOUR
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия (исправлено)
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = 0.0  ! x2(0) = t при t=0 => 0
! 
!     ! Настройки точности
!     RELERR = 1.0E-4
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати
!     TPRINT = 0.05
!     FINAL = 1.0  ! Интервал [0,1]
!     HOUR = 0.025
! 
!     ! Решение методом RKF45
!     CALL solve_rkf45()
! 
!     ! Решение методом Адамса
!     CALL solve_adams()
! 
! contains
! 
!     subroutine solve_rkf45()
!         ! Решение системы методом RKF45
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
! 
!         PRINT *, "Solution by RKF45 method:"
!         PRINT *, "t", "x1", "x2"
! 
!         do while (T < FINAL)
!             TOUT = min(T + TPRINT, FINAL)
!             CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             PRINT *, T, Y(1), Y(2)
!         end do
!     end subroutine solve_rkf45
! 
!     subroutine solve_adams()
!         ! Решение системы методом Адамса 2-го порядка
!         real :: Y_prev(2), F_prev(2), F_curr(2), F_next(2)
!         real :: h_adams, t_prev
!         integer :: i, steps, print_step
! 
!         ! Используем RKF45 для получения первых двух точек
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = 0.0
!         h_adams = 0.025  ! Шаг интегрирования
! 
!         PRINT *, "Solution by Adams method (h=0.025):"
!         PRINT *, "t", "x1", "x2"
! 
!         ! Первая точка (начальные условия)
!         CALL F_SYSTEM(T, Y, F_prev)
!         PRINT *, T, Y(1), Y(2)
! 
!         ! Вторая точка - получаем методом RKF45
!         TOUT = T + h_adams
!         CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!         CALL F_SYSTEM(T, Y, F_curr)
!         PRINT *, T, Y(1), Y(2)
! 
!         ! Сохраняем предыдущие значения
!         Y_prev = Y
!         t_prev = T
! 
!         ! Основной цикл метода Адамса
!         steps = nint((FINAL - T)/h_adams)
!         print_step = nint(TPRINT/h_adams)
! 
!         do i = 2, steps
!             ! Вычисляем следующее значение по методу Адамса
!             Y = Y_prev + h_adams * (3.0*F_curr - F_prev)/2.0
!             T = t_prev + h_adams
! 
!             ! Вычисляем производные в новой точке
!             CALL F_SYSTEM(T, Y, F_next)
! 
!             ! Обновляем предыдущие значения
!             Y_prev = Y
!             t_prev = T
!             F_prev = F_curr
!             F_curr = F_next
! 
!             ! Печатаем с шагом TPRINT
!             if (mod(i, print_step) == 0) then
!                 PRINT *, T, Y(1), Y(2)
!             end if
!         end do
!     end subroutine solve_adams
! 
! end program main
! 
! ! Система ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + LOG(1.0 + T**2)
!     YP(2) = Y(1) + EXP(-T) + T**2 + T
! END SUBROUTINE F_SYSTEM
! ! Вариант 14
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, HOUR
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия (исправлено)
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = T  ! По условию x2(0) = t
! 
!     ! Настройки точности
!     RELERR = 1.0E-4
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати (исправлено FINAL)
!     TPRINT = 0.05
!     FINAL = 1.0  ! Интервал [0,1]
!     HOUR = 0.025
! 
!     ! Заголовок
!     PRINT *, "t", "x1", "x2"
! 
!     ! Решение методом RKF45
!     CALL solve_rkf45()
!     
!     ! Решение методом Адамса
!     CALL solve_adams()
!     
! contains
! 
!     subroutine solve_rkf45()
!         ! Решение системы методом RKF45
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = T
!         
!         PRINT *, "Solution by RKF45 method:"
!         PRINT *, "t", "x1", "x2"
!         
!         do while (T < FINAL)
!             TOUT = min(T + TPRINT, FINAL)
!             CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             PRINT *, T, Y(1), Y(2)
!         end do
!     end subroutine solve_rkf45
! 
!     subroutine solve_adams()
!         ! Решение системы методом Адамса 2-го порядка
!         real :: Y_prev(2), F_prev(2), F_curr(2)
!         real :: h_adams
!         integer :: i, steps
!         
!         ! Используем RKF45 для получения первого шага
!         T = 0.0
!         Y(1) = -3.0
!         Y(2) = T
!         h_adams = 0.025  ! Шаг интегрирования
!         
!         PRINT *, "Solution by Adams method (h=0.025):"
!         PRINT *, "t", "x1", "x2"
!         
!         ! Первый шаг - получаем методом RKF45
!         TOUT = T + h_adams
!         CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!         PRINT *, T, Y(1), Y(2)
!         
!         ! Сохраняем предыдущие значения
!         Y_prev = Y
!         CALL F_SYSTEM(T-h_adams, Y_prev, F_prev)
!         
!         ! Основной цикл метода Адамса
!         steps = nint((FINAL - T)/h_adams)
!         do i = 1, steps
!             CALL F_SYSTEM(T, Y, F_curr)
!             Y = Y + h_adams * (3.0*F_curr - F_prev)/2.0
!             T = T + h_adams
!             F_prev = F_curr
!             
!             if (mod(i, nint(TPRINT/h_adams)) == 0) then
!                 PRINT *, T, Y(1), Y(2)
!             end if
!         end do
!     end subroutine solve_adams
! 
! end program main 
! 
! ! Исправленная система ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + LOG(1.0 + T**2)
!     YP(2) = Y(1) + EXP(-T) + T**2 + T  ! Исправлено последнее слагаемое
! END SUBROUTINE F_SYSTEM
! ! Вариант 15
! 
! program main
!     implicit none
! 
!     interface
!         subroutine RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!             implicit none
!             external :: F
!             integer, intent(in) :: NEQN
!             real, intent(inout) :: Y(NEQN), T, TOUT, RELERR, ABSERR
!             integer, intent(inout) :: IFLAG
!             real, intent(inout) :: WORK(*)
!             integer, intent(inout) :: IWORK(*)
!         end subroutine RKF45
!     end interface
! 
!     EXTERNAL F_SYSTEM
!     INTEGER :: NEQN, IFLAG, IWORK(5)
!     REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
!     REAL :: TPRINT, FINAL, HOUR
! 
!     ! Количество уравнений
!     NEQN = 2
! 
!     ! Начальные условия
!     T = 0.0
!     Y(1) = -3.0
!     Y(2) = 1.0
! 
!     ! Настройки точности
!     RELERR = 1.0E-4
!     ABSERR = 1.0E-4
!     IFLAG = 1
! 
!     ! Параметры печати
!     TPRINT = 0.05
!     FINAL = 0.1
!     HOUR = 0.025
! 
!     ! Заголовок
!     PRINT *, "t", "x1", "x2"
! 
! 10  CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
!     PRINT *, T, Y(1), Y(2)
! 
!     SELECT CASE (IFLAG)
!         CASE (1)
!             TOUT = TPRINT + T
!             IF (T < FINAL + HOUR/2.0) GO TO 10
!             STOP
! 
!         CASE (2)
!             PRINT *, "Current RELERR and ABSERR: ", RELERR, ABSERR
!             GO TO 10
! 
!         CASE (3)
!             PRINT *, "RKF45 Error occurred"
!             GO TO 10
! 
!         CASE (4)
!             ABSERR = 1.0E-6
!             PRINT *, "Updated ABSERR: ", ABSERR
!             GO TO 10
! 
!         CASE (5)
!             RELERR = RELERR * 10.0
!             PRINT *, "Updated RELERR: ", RELERR
!             IFLAG = 2
!             GO TO 10
! 
!         CASE (6)
!             PRINT *, "Stopping due to flag 6"
!             IFLAG = 2
!             GO TO 10
! 
!         CASE DEFAULT
!             PRINT *, "Unknown flag value. Stopping."
!             STOP
!     END SELECT
! contains
! 
! end program main 
! 
! ! Определение системы ОДУ
! SUBROUTINE F_SYSTEM(T, Y, YP)
!     IMPLICIT NONE
!     REAL, INTENT(IN) :: T, Y(2)
!     REAL, INTENT(OUT) :: YP(2)
! 
!     YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + LOG(1.0 + T**2)
!     YP(2) = Y(1) + EXP(-T) + T**2 + 1.0
! END SUBROUTINE F_SYSTEM
