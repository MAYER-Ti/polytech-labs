module IOGroup 
   use Environment
   implicit none

   integer, parameter ::  SURNAME_LEN = 15, INITIALS_LEN = 5, DATE_LEN = 4

contains
   subroutine ReadGroup(input_file, Surnames, Initials, Dates) 
      character(*),intent(in)                        :: input_file
      character(kind=CH_), allocatable, intent(out) :: Surnames(:,:)
      character(kind=CH_), allocatable, intent(out) :: Initials(:,:)
      integer, allocatable, intent(out)             :: Dates(:)
      
      integer :: i = 0, In = 0, IO = 0, GROUP_COUNT = 0
      character(:), allocatable :: format

      open (file=input_file, encoding=E_, newunit=In)
         read (In, '(i15)') GROUP_COUNT
         allocate(Surnames(SURNAME_LEN, GROUP_COUNT), Initials(INITIALS_LEN, GROUP_COUNT), Dates(GROUP_COUNT))
         format = '('//SURNAME_LEN//'a1, 1x, '//INITIALS_LEN//'a1, 1x, i'//DATE_LEN//')'
         read (In, format, iostat=IO) (Surnames(:, i), Initials(:, i), Dates(i), i = 1, GROUP_COUNT)
         call Handle_IO_status(IO, "reading group list")
      close (In)

   end subroutine ReadGroup 
   
   subroutine WriteGroup(output_file, Surnames, Initials, Dates, writeFilePostion, writeLetter)
      character(*), intent(in)                      :: output_file, writeFilePostion, writeLetter
      character(kind=CH_), allocatable, intent(in) :: Surnames(:,:)
      character(kind=CH_), allocatable, intent(in) :: Initials(:,:)
      integer                         :: Dates(:)

      integer :: i = 0, Out = 0, IO = 0, GROUP_COUNT
      character(:), allocatable :: format

      GROUP_COUNT = UBound(Surnames, 2)
      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         format = '('//SURNAME_LEN//'a1, 1x, '//INITIALS_LEN//'a1, 1x, i'//DATE_LEN//')'
         write(Out, format, iostat=IO) (Surnames(:, i), Initials(:, i), Dates(i), i = 1, GROUP_COUNT)
         call Handle_IO_status(IO, "writing group list")
      close (Out)
   end subroutine WriteGroup

   subroutine WriteElement(output_file, surname, initials, date, writeFilePostion, writeLetter)
      character(*), intent(in) :: output_file, writeFilePostion, writeLetter
      character(kind=CH_), intent(in) :: surname(SURNAME_LEN)
      character(kind=CH_), intent(in) :: initials(INITIALS_LEN) 
      integer, intent(in)                           :: date
      
      integer :: IO, Out
      character(:), allocatable :: format 

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         format = '('//SURNAME_LEN//'a1, 1x, '//INITIALS_LEN//'a1, 1x, i'//DATE_LEN//')'
         write(Out, format, iostat=IO) surname(:), initials(:), date
      close (Out)

   end subroutine WriteElement
end module IOGroup
