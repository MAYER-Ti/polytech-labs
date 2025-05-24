module Matrix_IO
   use Environment

   implicit none
contains
   subroutine ReadMatrix(input_file, Matrix, N, M)
      character(*), intent(in) :: input_file
      integer, intent(out)     :: N, M
      real(R_), allocatable, intent(out)    :: Matrix(:,:)


      integer :: In = 0, i = 0
   
      open (file=input_file, newunit=In)
         read (In, *) N, M
         allocate (Matrix(N,M))
         read (In, *) (Matrix(:,i), i = 1, M)
      close (In)

   end subroutine ReadMatrix
 
   subroutine WriteMatrix(output_file, Matrix)
      character(*), intent(in) :: output_file
      real(R_), intent(in)     :: Matrix(:,:)
      
      integer :: Out = 0, i = 0

      open (file=output_file, newunit=Out, position='append')
         write (Out, *) "Matrix:"
         write (Out, '('//UBound(Matrix, 2)//'f6.2)') (Matrix(:, i), i = 1, UBound(Matrix, 1))
      close (Out)
   end subroutine WriteMatrix
end module Matrix_IO
