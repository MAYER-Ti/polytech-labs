! Вариант 14

program main
    implicit none

!    interface
!        subroutine SPLINE(N, X, Y, B, C, D) 
!            integer, intent(in) :: N ! Число заданных точек или узлов
!            real, intent(in)    :: X(N) ! Абсциссы узлов в строго возрастающем порядке
!            real, intent(in)    :: Y(N) ! Ординаты узлов
!            real, intent(out)   :: B(N), C(N), D(N) ! Массивы определенных выше коэффициентов сплайна
!        end subroutine SPLINE
!    
!        function SEVAL(N, Xi, X, Y, B, C, D) result(seval_value) 
!            integer, intent(in) :: N 
!            real, intent(in)    :: Xi, X(N), Y(N), B(N), C(N), D(N) 
!            real                :: seval_value
!        end function SEVAL 
!
!    end interface
!
!    external quanc8
    EXTERNAL F_SYSTEM
    INTEGER :: NEQN, IFLAG, IWORK(5)
    REAL :: T, Y(2), TOUT, RELERR, ABSERR, WORK(50)
    REAL :: TPRINT, FINAL, HOUR

    ! Количество уравнений
    NEQN = 2

    ! Начальные условия
    T = 0.0
    Y(1) = -3.0
    Y(2) = 1.0

    ! Настройки точности
    RELERR = 1.0E-4
    ABSERR = 1.0E-4
    IFLAG = 1

    ! Параметры печати
    TPRINT = 0.05
    FINAL = 0.1
    HOUR = 0.025

    ! Заголовок
    PRINT *, "t", "x1", "x2"

10  CALL RKF45(F_SYSTEM, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
    PRINT *, T, Y(1), Y(2)

    SELECT CASE (IFLAG)
        CASE (1)
            TOUT = TPRINT + T
            IF (T < FINAL + HOUR/2.0) GO TO 10
            STOP

        CASE (2)
            PRINT *, "Current RELERR and ABSERR: ", RELERR, ABSERR
            GO TO 10

        CASE (3)
            PRINT *, "RKF45 Error occurred"
            GO TO 10

        CASE (4)
            ABSERR = 1.0E-6
            PRINT *, "Updated ABSERR: ", ABSERR
            GO TO 10

        CASE (5)
            RELERR = RELERR * 10.0
            PRINT *, "Updated RELERR: ", RELERR
            IFLAG = 2
            GO TO 10

        CASE (6)
            PRINT *, "Stopping due to flag 6"
            IFLAG = 2
            GO TO 10

        CASE DEFAULT
            PRINT *, "Unknown flag value. Stopping."
            STOP
    END SELECT
contains

end program main 

! Определение системы ОДУ
SUBROUTINE F_SYSTEM(T, Y, YP)
    IMPLICIT NONE
    REAL, INTENT(IN) :: T, Y(2)
    REAL, INTENT(OUT) :: YP(2)

    YP(1) = -73.0 * Y(1) - 210.0 * Y(2) + LOG(1.0 + T**2)
    YP(2) = Y(1) + EXP(-T) + T**2 + 1.0
END SUBROUTINE F_SYSTEM
