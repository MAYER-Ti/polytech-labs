MODULE integral_func_mod
    IMPLICIT NONE

    real :: m_mod

CONTAINS

    real FUNCTION integral_func(x) RESULT(func_value)
        real, intent(in) :: x
        func_value =  (abs(x*x + 2*x-3))**m_mod
    END FUNCTION integral_func


END MODULE integral_func_mod
