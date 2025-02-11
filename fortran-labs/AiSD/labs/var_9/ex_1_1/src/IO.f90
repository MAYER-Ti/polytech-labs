module IOGroup 
   use Environment
   implicit none

   integer, parameter ::  SURNAME_LEN = 15, INITIALS_LEN = 5, DATE_LEN = 4

contains
   subroutine ReadGroup(input_file, Surnames, Initials, Dates) 
      character(*),intent(in)                        :: input_file
      character(SURNAME_LEN, kind=CH_), allocatable, intent(out)  :: Surnames(:)
      character(INITIALS_LEN, kind=CH_), allocatable, intent(out) :: Initials(:)
      integer, allocatable, intent(out)                           :: Dates(:)
      
      integer :: i = 0, In = 0, IO = 0, GROUP_COUNT = 0

      open (file=input_file, encoding=E_, newunit=In)
         read (In, '(i15)') GROUP_COUNT
         allocate(Surnames(GROUP_COUNT), Initials(GROUP_COUNT), Dates(GROUP_COUNT))
         read (In, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) (Surnames(i), Initials(i), Dates(i), i = 1, GROUP_COUNT)
         call Handle_IO_status(IO, "reading group list")
      close (In)

   end subroutine ReadGroup 
   
   subroutine WriteGroup(output_file, Surnames, Initials, Dates, writeFilePostion, writeLetter)
      character(*), intent(in) :: output_file, writeFilePostion, writeLetter
      character(SURNAME_LEN, kind=CH_), allocatable, intent(in)  :: Surnames(:)
      character(INITIALS_LEN, kind=CH_), allocatable, intent(in) :: Initials(:)
      integer, allocatable, intent(in)                           :: Dates(:)

      integer :: i = 0, Out = 0, IO = 0, GROUP_COUNT

      GROUP_COUNT = Ubound(Surnames, 1)
      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         write(Out, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) (Surnames(i), Initials(i), Dates(i), i = 1, GROUP_COUNT)
         call Handle_IO_status(IO, "writing group list")
      close (Out)
   end subroutine WriteGroup

   subroutine WriteElement(output_file, surname, initials, date, writeFilePostion, writeLetter)
      character(*), intent(in) :: output_file, writeFilePostion, writeLetter
      character(SURNAME_LEN, kind=CH_), intent(in)  :: surname
      character(INITIALS_LEN, kind=CH_), intent(in) :: initials
      integer, intent(in)                           :: date
      
      integer :: IO, Out

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         write(Out, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) surname, initials, date
      close (Out)

   end subroutine WriteElement
!
!   subroutine WriteCountPositions(output_file, pos, counts, countPositions, writeFilePostion, writeLetter)
!      character(*), intent(in)                   :: output_file, writeFilePostion, writeLetter
!      character(BLOCK_LEN, kind=CH_), allocatable, intent(in) :: pos(:)
!      integer, allocatable, intent(in)           :: counts(:)     
!      integer, intent(in)                        :: countPositions
!
!      integer :: i = 0, Out = 0, IO = 0
!
!      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
!            write (Out, '(a)') writeLetter
!            write (Out, '('//countPositions//'(a, 1x, i3,/))', iostat=IO) &
!                (pos(i), counts(i), i = 1, countPositions) 
!            call Handle_IO_status(IO, "write employee positions")
!      close (Out)     
!
!   end subroutine WriteCountPositions

end module IOGroup
