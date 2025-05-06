program variable_length_pendulum
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

        real function QUANC8(F, A, B, ABSERR, RELERR, RESULT, ESTERR, NOFUN)
            implicit none
            external :: F
            real, intent(in) :: A, B, ABSERR, RELERR
            real, intent(out) :: RESULT, ESTERR
            integer, intent(out) :: NOFUN
        end function QUANC8
    end interface

    external :: system_ode

    integer, parameter :: NEQN = 4
    real :: Y(NEQN), T, TOUT, RELERR, ABSERR
    integer :: IFLAG, IWORK(5)
    real :: WORK(100)
    real :: FINAL, TPRINT

    ! Начальные условия
    Y(1) = 0.1        ! x(0)
    Y(2) = 0.0        ! x'(0)
    Y(3) = 0.2        ! theta(0)
    Y(4) = 0.0        ! theta'(0)

    T = 0.0
    FINAL = 4.0
    TPRINT = 0.05
    TOUT = T + TPRINT

    RELERR = 1.0E-6
    ABSERR = 1.0E-6
    IFLAG = 1

    print *, "t", "x(t)", "x'(t)", "theta(t)", "theta'(t)"
    do while (T < FINAL)
        call RKF45(system_ode, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
        if (IFLAG /= 2) then
            print *, "Ошибка в RKF45, IFLAG =", IFLAG
            exit
        end if
        print '(F6.2, 4(2X, F12.6))', T, Y(1), Y(2), Y(3), Y(4)
        TOUT = min(TOUT + TPRINT, FINAL)
    end do

end program variable_length_pendulum

subroutine system_ode(t, y, yp)
    implicit none
    real, intent(in) :: t, y(4)
    real, intent(out) :: yp(4)

    real :: x, xdot, theta, thetadot, denom

    ! Параметры системы
    real, parameter :: M = 1.0, K = 10.0, L = 1.0, g = 9.81

    x = y(1)
    xdot = y(2)
    theta = y(3)
    thetadot = y(4)

    yp(1) = xdot
    yp(3) = thetadot

    denom = L + x
    yp(2) = -(K/M)*x - g*(1.0 - cos(theta)) + denom * thetadot**2
    yp(4) = -g/denom*sin(theta) - (2.0/denom)*xdot*thetadot
end subroutine system_ode
