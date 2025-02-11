module MatrixIO
   use Environment
   
   implicit none
   interface ReadMatrix
       module procedure ReadMatrix_size
       module procedure ReadMatrix_unsize
   end interface
contains
   subroutine ReadMatrix_size(input_file, Matrix, N, M)
      character(*), intent(in) :: input_file
      integer, intent(out)     :: N, M
      real(R_), allocatable, intent(out)    :: Matrix(:,:)

      integer :: In = 0, i = 0
   
      open (file=input_file, newunit=In)
         read (In, *) N, M
         allocate (Matrix(N,M))
         !dir$ attributes align a: 32 :: a
         read (In, *) (Matrix(:,i), i = 1, M)
      close (In)
   end subroutine ReadMatrix_size
   
   subroutine ReadMatrix_unsize(input_file, Matrix)
      character(*), intent(in) :: input_file
      real(R_), allocatable, intent(out) :: Matrix(:,:)
      
      integer :: In = 0, N = 0, M = 0, i = 0

      open (file=input_file, newunit=In)
         read (In, *) N, M
         allocate (Matrix(N, M))
         !dir$ attributes align a: 32 :: a
         read (In, *) (Matrix(:,i), i = 1, N)
      close(In) 
   end subroutine ReadMatrix_unsize

   subroutine WriteMatrix(output_file, Matrix)
      character(*), intent(in) :: output_file
      real(R_), intent(in)     :: Matrix(:,:)
      
      integer :: Out = 0, i = 0

      open (file=output_file, newunit=Out, position='append')
         write (out, *) "Матрица:", UBound(Matrix, 2), UBound(Matrix, 1)
         write (Out, '('//UBound(Matrix, 2)//'f6.2)') (Matrix(:, i), i = 1, UBound(Matrix, 1))
      close (Out)
   end subroutine WriteMatrix
end module MatrixIO
