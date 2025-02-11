!   Сделать отображение ранга ссылки, взглянув на двумерную матрицу как на одномерный массив.
!   Просумировать в одномерном массиве каждый N+1-ый элемент (UBound).
!   Матрицу принимать как target, contigious, intent(inout)
module SumDiagMatrix 
   use Environment

   implicit none

contains
   pure subroutine SumDiag(Matrix, res)
      real(R_), contiguous, target, intent(inout)    :: Matrix(:,:)
      real(R_), intent(out) :: res
      integer :: N, i
      real(R_), pointer :: array(:)

      N = UBound(Matrix, 1)
      array(1:N*N) => matrix 
      do i = 1, N*N, N+1
         res = res + array(i) 
      end do
   end subroutine SumDiag

end module SumDiagMatrix 
