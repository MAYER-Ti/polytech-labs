module pendulum_params
    implicit none
    real :: L, M, K
end module pendulum_params

program variable_length_pendulum
    use pendulum_params
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

        subroutine DECOMP(NDIM, N, A, COND, IPVT, WORK)
            integer, intent(in) :: NDIM, N
            real, intent(inout) :: A(NDIM, N)
            real, intent(out) :: WORK(N)
            integer, intent(out) :: IPVT(N)
            real, intent(out) :: COND
        end subroutine DECOMP

        subroutine SOLVE(NDIM, N, A, B, IPVT)
            integer, intent(in) :: NDIM, N, IPVT(N)
            real, intent(inout) :: A(NDIM, N)
            real, intent(inout) :: B(N)
        end subroutine SOLVE
    end interface

    external quanc8

    !external :: system_ode, integrand

    integer, parameter :: NEQN = 4
    real :: Y(NEQN), T, TOUT, RELERR, ABSERR
    integer :: IFLAG, IWORK(5)
    real :: WORK(100)
    real :: FINAL, TPRINT
    real :: A_init, B_init, C_init, D_init

    ! Инициализация параметров и начальных условий
    call initialize_parameters(A_init, B_init, C_init, D_init)
    Y = [A_init, B_init, C_init, D_init]

    CALL print_parameters(A_init, B_init, C_init, D_init)

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

contains

    subroutine initialize_parameters(A, B, C, D)
        use pendulum_params
        real :: A, B, C, D
        real :: MAT(4,4), RHS(4), COND, W(4), X(4)
        integer :: IP(4), I
        integer :: nfun
        real :: xstar, a_integ, b_integ, abserr_integ, relerr_integ, res, esterr, flag

        ! Система линейных уравнений
        MAT(1,:) = [10.0,  1.0,  4.0,  0.0]
        MAT(2,:) = [ 1.0, 10.0,  5.0, -1.0]
        MAT(3,:) = [ 4.0,  5.0, 10.0,  7.0]
        MAT(4,:) = [ 0.0, -1.0,  7.0,  9.0]
        RHS = [16.0, 20.0, 40.0, 28.0]

        call DECOMP(4, 4, MAT, COND, IP, W)
        print *, 'COND=', COND

        X = RHS
        call SOLVE(4, 4, MAT, X, IP)

        A = X(1)
        B = X(2)
        C = X(3)
        D = X(4)

        ! Найти x*, корень уравнения exp(-x) + x^2 = 2 методом Ньютона
        xstar = 1.0
        do
            if (abs(exp(-xstar) + xstar**2 - 2.0) < 1.0e-7) exit
            xstar = xstar - (exp(-xstar) + xstar**2 - 2.0) / (-exp(-xstar) + 2*xstar)
        end do

        print *, 'xstar res', xstar

        M = 0.7598945 * xstar
        K = 39.24

        ! Вычисление L через QUANC8
        a_integ = 1.0
        b_integ = 5.0
        abserr_integ = 0.0
        relerr_integ = 1.e-06
        call QUANC8(integrand, a_integ, b_integ, abserr_integ, relerr_integ, res, esterr, nfun, flag)
        print *, 'quanc8 res', res
        L = 1.0 + (res - 1.0507242)**4
    end subroutine initialize_parameters

    subroutine system_ode(t, y, yp)
        use pendulum_params
        implicit none
        real, intent(in) :: t, y(4)
        real, intent(out) :: yp(4)
        real, parameter :: g = 9.81
        real :: x, xdot, theta, thetadot, denom

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

    real function integrand(x)
        real, intent(in) :: x
        integrand = 1.0 / (sqrt(x) * (1 + x ** (1.0/3.0)))
    end function integrand

    subroutine print_parameters(A, B, C, D)
        use pendulum_params
        real :: A, B, C, D
        print *, "=============================================="
        print *, "Начальные условия (решение СЛАУ):"
        print *, "A =", A, ", B =", B, ", C =", C, ", D =", D
        print *, "Параметры системы:"
        print *, "L =", L, ", M =", M, ", K =", K
        print *, "=============================================="


    end subroutine print_parameters

end program variable_length_pendulum
