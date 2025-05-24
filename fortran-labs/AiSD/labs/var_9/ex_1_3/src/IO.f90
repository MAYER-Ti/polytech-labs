module IOGroup 
   use Environment
   implicit none

   integer, parameter :: SURNAME_LEN = 15, INITIALS_LEN = 5, DATE_LEN = 4

   type student
      character(SURNAME_LEN, kind=CH_)  :: sur = ""
      character(INITIALS_LEN, kind=CH_) :: init = ""
      integer                           :: date = 0
   end type student
contains
   subroutine CreateDataFile(input_file, data_file, GROUP_COUNT)
      character(*), intent(in) :: input_file, data_file
      integer, intent(inout)   :: GROUP_COUNT

      type(student) :: stud 
      integer       :: In, Out, IO, i, sizeOfOneStud
      character(:), allocatable :: format

      open (file=input_file, encoding=E_, newunit=In)
      read (In, '(i15)') GROUP_COUNT
      sizeOfOneStud = (SURNAME_LEN+INITIALS_LEN+2)*CH_ + I_
      open (file=data_file, form='unformatted', newunit=Out, access='direct', recl=sizeOfOneStud)
         format = '(a, 1x, a, 1x, i'//DATE_LEN//')'
         do i = 1, GROUP_COUNT
            ! Чтение входного файла
            read (In, format, iostat=IO) stud
            call Handle_IO_status(IO, "Ошибка чтения из входного файла-"//i)
            ! Запись в бинарный файл
            write (Out, iostat=IO, rec=i) stud
            call Handle_IO_status(IO, "Ошибка записи в бинарный файл!")
         end do
      close (Out)
      close (In)
   end subroutine CreateDataFile

   function ReadGroup(data_file, GROUP_COUNT) result(group)
      character(*),intent(in)    :: data_file
      integer, intent(in)        :: GROUP_COUNT

      type(student), allocatable :: group(:)
      integer :: i, In, IO, sizeOfOneStud
      
      sizeOfOneStud = (SURNAME_LEN + INITIALS_LEN+2)*CH_ + I_
      allocate(group(GROUP_COUNT))
      open (file=data_file, form='unformatted', newunit=In, access='direct', recl=sizeOfOneStud)
      do i = 1, GROUP_COUNT
         read (In, iostat=IO, rec=i) group(i) 
         call Handle_IO_status(IO, "Ошибка чтения данных")
      end do
      close (In)

   end function ReadGroup 
   
   subroutine WriteGroup(output_file, Group, writeFilePostion, writeLetter)
      character(*), intent(in)  :: output_file, writeFilePostion, writeLetter
      type(student), allocatable, intent(in) :: Group(:)

      integer :: Out = 0, IO = 0
      character(:), allocatable :: format

      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         format = '(a, 1x, a, 1x, i'//DATE_LEN//')'
         write(Out, '(a)') writeLetter
         write(Out, format, iostat=IO) Group 
         call Handle_IO_status(IO, "Ошибка вывода данных")
      close (Out)
   end subroutine WriteGroup

   subroutine WriteElement(output_file, stud, writeFilePostion, writeLetter)
      character(*), intent(in) :: output_file, writeFilePostion, writeLetter
      type(student), intent(in) :: stud
      
      integer :: IO, Out

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         write(Out, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) stud 
      close (Out)

   end subroutine WriteElement

end module IOGroup
