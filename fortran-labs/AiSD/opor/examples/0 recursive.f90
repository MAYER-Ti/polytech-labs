pure recursive integer function Fact_Times(N, Acc)
	integer, intent(in) :: N, Acc
	if (N == 0) then
		Fact_Times = Acc
	else
		Fact_Times = Fact_Times(N - 1, Acc * N)
	end if
end function Fact_Times

pure integer function Factorial(N)
	integer, intent(in) :: N
	Factrorial = Fac_Times (N, 1)
end function

! Во что может развернуть компилятор:
pure integer function Factorial(N)
	integer, intent(in) :: N
	
	integer :: Acc = 1, _N = N
	
	do while (_N /= 0)
	   Acc = Acc * N
	   _N = _N - 1
	end do
	Factrorial = Acc
end function
