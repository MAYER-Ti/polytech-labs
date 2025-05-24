module IOEmployee 
   use Environment
   use globalVars
   implicit none
contains
   subroutine ReadEmployee(input_file, surnames, positions) 
      character(*),intent(in)         :: input_file
      character(kind=CH_), allocatable, intent(out) :: surnames(:,:), positions(:,:)
      
      integer :: i, In, IO, sizeDatas 
      character(:), allocatable :: format

      open (file=input_file, encoding=E_, newunit=In)
         read(In, '(i15)') sizeDatas
         allocate(surnames(sizeDatas, BLOCK_LEN), positions(sizeDatas, BLOCK_LEN))
         format = '('//BLOCK_LEN//'a1, 1x, '//BLOCK_LEN//'a1)'
         read (In, format, iostat=IO) (surnames(i,:), positions(i,:), i = 1, sizeDatas)
         call Handle_IO_status(IO, "reading employee list")
      close (In)

   end subroutine ReadEmployee 
   
   subroutine WriteEmployee(output_file, surnames, positions, writeFilePostion, writeLetter)
      character(*), intent(in)        :: output_file, writeFilePostion, writeLetter
      character(kind=CH_), allocatable, intent(in) :: surnames(:,:), positions(:,:)

      integer :: i = 0, Out = 0, IO = 0
      character(:), allocatable :: format

      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         format = '('//BLOCK_LEN//'a1, 1x, '//BLOCK_LEN//'a1)'
         write(Out, '(a)') writeLetter
         write(Out, format, iostat=IO) (surnames(i,:), positions(i,:), i = 1, Ubound(positions, 1))
         call Handle_IO_status(IO, "writing employee list")
      close (Out)
    end subroutine WriteEmployee

   subroutine WriteCountPositions(output_file, pos, counts, writeFilePostion, writeLetter)
      character(*), intent(in)        :: output_file, writeFilePostion, writeLetter
      character(kind=CH_), allocatable, intent(in) :: pos(:, :)      
      integer, allocatable                         :: counts(:)

      integer :: i = 0, Out = 0, IO = 0 

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
            write (Out, '(a)') writeLetter
            write (Out, '('//Ubound(pos, 1)//'('//BLOCK_LEN//'a1, 1x, i7,/))', iostat=IO) &
                (pos(i,:), counts(i), i = 1, Ubound(pos, 1))
            call Handle_IO_status(IO, "write employee positions")
      close (Out)     

   end subroutine WriteCountPositions

end module IOEmployee 
