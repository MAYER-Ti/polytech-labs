program matrix_analysis
    implicit none
    integer, parameter :: NDIM = 8
    real :: A(NDIM, NDIM), AINV(NDIM, NDIM), R(NDIM, NDIM)
    real :: WORK(NDIM) = 0, COND = 0, norm_R = 0
    integer :: IPVT(NDIM) = 0
    integer :: p
    real, dimension(6) :: p_values = [1.0, 0.1, 0.01, 0.0001, 0.000001, 0.0]

    interface
        subroutine DECOMP(NDIM, N, A, COND, IPVT, WORK)
            integer, intent(in) :: NDIM, N
            real, intent(inout) :: A(NDIM, N)
            real, intent(out) :: WORK(N)
            integer, intent(out) :: IPVT(N)
            real, intent(out) :: COND
        end subroutine DECOMP

        subroutine SOLVE(NDIM, N, A, B, IPVT)
            integer, intent(in) :: NDIM, N, IPVT(N)
            real, intent(in) :: A(NDIM, N)
            real, intent(out) :: B(N)
        end subroutine SOLVE
    end interface

    ! Перебор значений параметра p
    do p = 1, size(p_values)
        print *, "-------------------------------------"
        write (*,'(a, F16.8)') "Calculations for p =", p_values(p)
        call initialize_matrix(A, NDIM, p_values(p))

        ! Вывод исходной матрицы A
        print *, "Matrix A:"
        call print_matrix(A, NDIM, NDIM)

        ! Вычисление обратной матрицы AINV
        call compute_inverse(NDIM, NDIM, A, AINV, COND, IPVT, WORK)
        print *, "Inverse Matrix AINV:"
        call print_matrix(AINV, NDIM, NDIM)

        ! Вычисление матрицы невязки R
        call compute_residual(NDIM, NDIM, A, AINV, R)
        print *, "Residual Matrix R = E - A * AINV:"
        call print_matrix(R, NDIM, NDIM)

        ! Норма матрицы R
        norm_R = compute_norm(NDIM, NDIM, R)
        write (*,'(a, F20.8)') "Condition number (COND):", COND
        write (*,'(a, F16.8)') "Norm of Residual Matrix R:", norm_R
    end do

contains

    ! Подпрограмма инициализации матрицы A
    subroutine initialize_matrix(A, NDIM, p)
        integer, intent(in) :: NDIM
        real, intent(in) :: p
        real, intent(out) :: A(NDIM, NDIM)

        A = 0.0  ! Обнуляем матрицу
        A(1,:) = [p + 6.0,   2.0,   6.0,  8.0, -2.0,   1.0,   8.0, -5.0]
        A(2,:) = [    6.0, -22.0,  -2.0, -1.0,  0.0,   5.0,  -6.0,  4.0]
        A(3,:) = [   -2.0,  -3.0, -16.0,  0.0,  0.0,  -4.0,   2.0, -5.0]
        A(4,:) = [    1.0,   1.0,   4.0,  9.0,  1.0,   0.0,   0.0, -6.0]
        A(5,:) = [    0.0,   2.0,   0.0,  2.0, -3.0,  -5.0,   7.0,  5.0]
        A(6,:) = [    6.0,  -2.0,  -4.0,  2.0, -8.0, -12.0,   3.0, -3.0]
        A(7,:) = [   -6.0,  -6.0,   0.0, -8.0,  0.0,   5.0, -15.0,  0.0]
        A(8,:) = [    0.0,   7.0,   6.0,  0.0, -5.0,  -8.0,  -5.0, -3.0]
    end subroutine initialize_matrix

    ! Подпрограмма вычисления обратной матрицы
    subroutine compute_inverse(NDIM, N, A, AINV, COND, IPVT, WORK)
        integer, intent(in) :: NDIM, N
        real, intent(in) :: A(NDIM, N)
        real, intent(out) :: AINV(NDIM, N)
        real, intent(out) :: COND
        integer, intent(out) :: IPVT(N)
        real, intent(out) :: WORK(N)
        real :: B(N)
        integer :: j
        real :: ATMP(NDIM,N)

        ATMP = A  ! Копируем A в AINV
        AINV = 0.0

        call DECOMP(NDIM, N, ATMP, COND, IPVT, WORK)

        do j = 1, N
            B = 0.0
            B(j) = 1.0
            call SOLVE(NDIM, N, ATMP, B, IPVT)
            AINV(:, j) = B
        end do
    end subroutine compute_inverse

    ! Подпрограмма вычисления матрицы невязки R
    subroutine compute_residual(NDIM, N, A, AINV, R)
        integer, intent(in) :: NDIM, N
        real, intent(in) :: A(NDIM, N), AINV(NDIM, N)
        real, intent(out) :: R(NDIM, N)
        real :: temp(NDIM, N)
        integer :: i

        temp = MATMUL(A, AINV)  ! A * AINV
        R = 0.0                 ! Инициализация R как единичной матрицы
        do i = 1, N
            R(i, i) = 1.0
        end do
        R = R - temp            ! R = E - temp
    end subroutine compute_residual

    ! Подпрограмма вычисления нормы матрицы
    function compute_norm(NDIM, N, R) result(norm)
        integer, intent(in) :: NDIM, N
        real, intent(in) :: R(NDIM, N)
        real :: norm
        integer :: i, j

        norm = 0.0
        do i = 1, N
            do j = 1, N
                norm = norm + R(i, j) ** 2
            end do
        end do
        norm = sqrt(norm)
    end function compute_norm

    ! Подпрограмма для вывода матрицы
    subroutine print_matrix(A, rows, cols)
        integer, intent(in) :: rows, cols
        real, intent(in) :: A(rows, cols)
        integer :: i, j

        do i = 1, rows
            write(*, "(8F20.8)") (A(i, j), j = 1, cols)
        end do
    end subroutine print_matrix

end program matrix_analysis

