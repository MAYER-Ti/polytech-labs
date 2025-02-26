MODULE integral_func_mod
    IMPLICIT NONE

CONTAINS

    real FUNCTION integral_func(x) RESULT(func_value)
        real, intent(in) :: x
        func_value = 1.0 / (EXP(x) * x)
    END FUNCTION integral_func


END MODULE integral_func_mod
