module pendulum_params
    implicit none
    real :: global_omega0, global_tau, global_mu
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


    integer, parameter :: NEQN = 3
    real :: Y(NEQN), T, TOUT, RELERR, ABSERR
    integer :: IFLAG, IWORK(5)
    real :: WORK(100)
    real :: FINAL_T, TPRINT
    real :: A_init, B_init, C_init

    ! Инициализация параметров и начальных условий
    call initialize_parameters(A_init, B_init, C_init)
    Y = [A_init, B_init, C_init]

    CALL print_parameters(A_init, B_init, C_init)

    T = 0.0
    FINAL_T = 10.0
    TPRINT = 0.1
    TOUT = T + TPRINT
    RELERR = 1.0E-6
    ABSERR = 1.0E-6
    IFLAG = 1

    print *, "     t            V(t)           V'(t)           z(t)"
    print *, "----------------------------------------------------------"

    do while (T < FINAL_T)
        call RKF45(F_VDP, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
        if (IFLAG /= 2) then
            print *, "Ошибка в RKF45, IFLAG =", IFLAG
            exit
        end if
        print '(F6.2, 3(2X, F12.6))', T, Y(1), Y(2), Y(3)
        TOUT = min(TOUT + TPRINT, FINAL_T)
    end do

contains

    subroutine initialize_parameters(A, B, C)
        use pendulum_params
        real :: A, B, C
        real :: MAT(3,3), RHS(3), COND, W(3), X(3)
        integer :: IP(3)
        integer :: nfun
        real :: xstar, a_integ, b_integ, abserr_integ, relerr_integ, res, esterr, flag
        real, parameter :: pi = 1415927

        ! Система линейных уравнений
        MAT(1,:) = [ 16.0,  24.0, 18.0 ]
        MAT(2,:) = [-24.0, 46.0, -42.0 ]
        MAT(3,:) = [ 18.0, -42.0, 49.0 ]
        RHS = [50.0, -90.0, 85.0]

        call DECOMP(3, 3, MAT, COND, IP, W)
        print *, 'COND=', COND

        X = RHS
        call SOLVE(3, 3, MAT, X, IP)

        A = X(1)
        B = X(2)
        C = X(3)

        ! Найти x*, корень уравнения tan((pi*x)/4) = x + 3 методом бисекции
        xstar = bisect(1.0, 1.75, 1.0e-7)

        print *, 'xstar res', xstar

        global_tau = 0.05763710 * xstar
        !global_tau = 1.73499428
        global_mu = 0.1

        ! Вычисление Omega0 через QUANC8
        a_integ = 1.0
        b_integ = 5.0
        abserr_integ = 0.0
        relerr_integ = 1.e-06
        call QUANC8(integrand, a_integ, b_integ, abserr_integ, relerr_integ, res, esterr, nfun, flag)
        print *, 'quanc8 res', res
        global_omega0 = 0.9517245 * res

    end subroutine initialize_parameters

    subroutine F_VDP(T, Y, YP)
        implicit none
        real, intent(in) :: T, Y(3)
        real, intent(out) :: YP(3)
        real :: w0, mu, tau

        w0 = global_omega0
        mu = global_mu
        tau = global_tau

        YP(1) = Y(2)
        YP(3) = (Y(1)**2 - Y(3)) / tau
        YP(2) = -w0**2 * Y(1) + 2.0 * mu * ( -YP(3) * Y(1) + (1.0 - Y(3)) * Y(2) )
    end subroutine F_VDP

    real function integrand(x)
        real, intent(in) :: x
        integrand = 1.0 / (sqrt(x) * (1 + x ** (1.0/3.0)))
    end function integrand

    subroutine print_parameters(A, B, C)
        use pendulum_params
        real :: A, B, C
        print *, "=============================================="
        print *, "Начальные условия (решение СЛАУ):"
        print *, "A =", A, ", B =", B, ", C =", C
        print *, "Параметры системы:"
        print *, "omega0 =", global_omega0, ",  tau =", global_tau, ", mu =", global_mu
        print *, "=============================================="


    end subroutine print_parameters

    real function bisect(a, b, tol)
        real, intent(in) :: a, b, tol

        real :: fa, fb, fx, x, tmp_a, tmp_b
        real, parameter :: pi = 3.1415927
        integer :: max_iter, i

        tmp_a = a
        tmp_b = b
        max_iter = 100

        do i = 1, max_iter
            x = 0.5 * (tmp_a + tmp_b)
            fa = tan(pi * tmp_a / 4.0) - tmp_a - 3.0
            fb = tan(pi * tmp_b / 4.0) - tmp_b - 3.0
            fx = tan(pi * x / 4.0) - x - 3.0

            if (abs(fx) < tol) exit

            if (fa * fx < 0.0) then
                tmp_b = x
            else
                tmp_a = x
            end if
        end do
        bisect = x
    end function bisect

end program variable_length_pendulum
