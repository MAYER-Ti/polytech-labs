module MyFunc 
   use Environment

   implicit none
   
contains
   real(R_) elemental function f(x) result(res)
      real(R_), intent(in) :: x
      
      real(R_)    r, q, x_2, oldRes
      integer     n

      ! Чтобы не вычислять каждый раз.
      x_2   = x * x
      
      n     = 0
      r     = x 
      res  = r

      ! Цикл с постусловием: пока сумма не перестанет меняться.
      do
         q        = x_2 * ((n + 0.5)*(n + 0.5))/((n+1)*(n+1.5))
         n        = n + 1
         r        = r * q
         oldRes   = res
         res      = res - r
         if (oldRes == res) exit
      end do
   end function f

   pure function q(X)
      real(R_), allocatable, intent(in) :: X(:) 
      real(R_), allocatable             :: q(:)
      q = (1 + f(X))/2.75

   end function q


end module MyFunc
