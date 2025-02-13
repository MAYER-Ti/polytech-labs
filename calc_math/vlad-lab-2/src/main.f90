PROGRAM Main
  IMPLICIT NONE
  INTERFACE
     SUBROUTINE DECOMP(NDIM, N, A, COND, IPVT, WORK)
       INTEGER NDIM, N
       REAL A(NDIM, N), COND, WORK(N)
       INTEGER IPVT(N)
     END SUBROUTINE DECOMP

     SUBROUTINE SOLVE(NDIM, N, A, B, IPVT)
       INTEGER NDIM, N
       REAL A(NDIM, N), B(N)
       INTEGER IPVT(N)
     END SUBROUTINE SOLVE
  END INTERFACE

  ! Параметры задачи
  INTEGER, PARAMETER :: N = 6
  REAL, PARAMETER :: ALPHA_VALUES(4) = (/0.0, 0.25, 0.49, 0.499/)
  REAL, DIMENSION(N, N) :: A
  REAL, DIMENSION(N) :: Z, G, X, WORK, TEMP_ARRAY
  INTEGER, DIMENSION(N) :: IPVT
  REAL :: COND, MAX_G, RELATIVE_ERROR
  INTEGER :: I, I2, I3, J, K
  REAL :: ALPHA

  ! Вычисление точного решения g_k
  DO K = 1, N
     G(K) = 2.0 ** (K - 2)
  END DO
  MAX_G = MAXVAL(ABS(G))

  ! Вывод вектора Z
  PRINT *, "Вектор G:"
  PRINT "(6F10.3)",  G(:)

  ! Перебор значений ALPHA
  DO I = 1, SIZE(ALPHA_VALUES)
     ALPHA = ALPHA_VALUES(I)
     PRINT *, "-----------------------------------------"
     PRINT *, "ALPHA = ", ALPHA
     PRINT *, "-----------------------------------------"

     ! Формирование матрицы A
     DO I2 = 1, N
        DO J = 1, N
           IF (I2 <= J) THEN
              A(I2, J) = J - I2 + 1
           ELSE
              A(I2, J) = ALPHA
           END IF
        END DO
     END DO

     ! Вывод матрицы A с обозначением строк и столбцов
     PRINT *, "Матрица A:"
     PRINT "(6F7.3)", (A(I3,:), I3 = 1, N)

     ! Формирование вектора Z
     DO I3 = 1, N
        Z(I3) = ALPHA * SUM(G(1:I3-1))

        DO J = I3, N
           TEMP_ARRAY(J) = (J - I3 + 1) * G(J)
        END DO

        Z(I3) = Z(I3) + SUM(TEMP_ARRAY(I3:N))
     END DO

     ! Вывод вектора Z
     PRINT *, "Вектор Z:"
     PRINT "(6F10.3)",  Z(:)

     ! Выполнение LU-разложения
     CALL DECOMP(N, N, A, COND, IPVT, WORK)
     PRINT *, "Оценка обусловленности (COND): ", COND

     ! Решение системы
     X = Z
     CALL SOLVE(N, N, A, X, IPVT)
     PRINT *, "Решение X:"
     PRINT "(6F10.3)", (X(J), J=1, N)

     ! Вычисление относительной ошибки
     RELATIVE_ERROR = FNORM2(X - G) / MAX_G
     PRINT *, "Относительная ошибка ||X - G|| / ||G||: ", RELATIVE_ERROR
     PRINT *, "-----------------------------------------"
  END DO
CONTAINS
  ! Вычисление нормы 2
  FUNCTION FNORM2(VEC)
    REAL, DIMENSION(:), INTENT(IN) :: VEC
    REAL :: FNORM2
    FNORM2 = SQRT(SUM(VEC ** 2))
  END FUNCTION FNORM2
END PROGRAM Main

