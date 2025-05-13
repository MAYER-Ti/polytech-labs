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
    TPRINT = 0.2
    TOUT = T + TPRINT
    RELERR = 1.0E-6
    ABSERR = 1.0E-6
    IFLAG = 1

    print *, "t", "V(t)", "V'(t)", "z(t)"
    do while (T < FINAL_T)
        call RKF45(system_ode, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
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
        xstar = bisect_root(0.1, 2.0, 1.0E-7)

        print *, 'xstar res', xstar

        global_tau = 0.05763710 * xstar
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

    subroutine system_ode(t, y, yp)
        use pendulum_params
        implicit none
        real, intent(in) :: t, y(3)
        real, intent(inout) :: yp(3)

        yp(1) = y(2)
        yp(3) = (y(1)**2 - y(3)) / global_tau
        yp(2) = -global_omega0**2 * y(1) + 2.0 * global_mu * (-yp(3) * y(1) + (1.0 - y(3)) * y(2))

    end subroutine system_ode

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

    real function bisect_root(a, b, tol)
        real, intent(in) :: a, b, tol
        real :: tmp_a, tmp_b
        real :: fa, fb, fm, m
        integer :: max_iter, i
        tmp_a = a
        tmp_b = b
        max_iter = 100
        fa = f_root(a)
        fb = f_root(b)
        if (fa * fb > 0.0) then
            print *, 'Корень вне интервала'
            bisect_root = tmp_a
            return
        end if
        do i = 1, max_iter
            m = 0.5 * (tmp_a + tmp_b)
            fm = f_root(m)
            if (abs(fm) < tol) exit
            if (fa * fm < 0.0) then
                tmp_b = m
                fb = fm
            else
                tmp_a = m
                fa = fm
            end if
        end do
        bisect_root = m
    end function bisect_root

    real function f_root(x)
    real, intent(in) :: x
    real, parameter :: pi = 3.1415927
    f_root = tan(pi*x/4.0) - (x + 3.0)
end function f_root

end program variable_length_pendulum
