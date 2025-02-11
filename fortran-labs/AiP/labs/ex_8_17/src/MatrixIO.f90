module MatrixIO
   use Environment
   
   implicit none
   interface ReadMatrix
       module procedure ReadMatrix_size
       module procedure ReadMatrix_unsize
   !   subroutine ReadMatrix_sub(input_file, Matrix, N, M)
   !       character(*) input_file
   !       real Matrix
   !       integer N, M
   !   end subroutine ReadMatrix_sub
   !   real function ReadMatrix_func(input_file)
   !       character(*) input_file
   !   end function ReadMatrix_func
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
         read (In, *) (Matrix(:,i), i = 1, N)
      close(In) 
   end subroutine ReadMatrix_unsize

   subroutine WriteMatrix(output_file, Matrix)
      character(*), intent(in) :: output_file
      real(R_), intent(in)     :: Matrix(:,:)
      
      integer :: Out = 0, i = 0

      open (file=output_file, newunit=Out, position='append')
         write (out, *) "Матрица:"
         write (Out, '('//UBound(Matrix, 2)//'f6.2)') (Matrix(:, i), i = 1, UBound(Matrix, 1))
      close (Out)
   end subroutine WriteMatrix
end module MatrixIO
