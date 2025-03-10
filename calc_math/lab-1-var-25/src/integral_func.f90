MODULE integral_func_mod
    IMPLICIT NONE

    real :: x, h

CONTAINS

    real FUNCTION integral_func(z) RESULT(func_value)
        real, intent(in) :: z
        func_value = 1.0 / (EXP(z) * (z + x))
    END FUNCTION integral_func


END MODULE integral_func_mod
