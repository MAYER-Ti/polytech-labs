module IOGroup 
   use Environment
   implicit none

   integer, parameter :: SURNAME_LEN = 15, INITIALS_LEN = 5, DATE_LEN = 4

   type student
      character(SURNAME_LEN, kind=CH_)  :: sur
      character(INITIALS_LEN, kind=CH_) :: init
      integer                           :: date
      type(student), pointer            :: next => Null()
   end type student
contains
   function ReadGroup(input_file) result(group)

      character(*), intent(in) :: input_file 

      type(student), pointer  :: Group 
      integer :: In

      open (file=Input_File, encoding=E_, newunit=In)
        Group => ReadValue(In)
      close (In)

   end function ReadGroup 
      ! Чтение следующего значения.
   recursive function ReadValue(In) result(Elem)
      integer, intent(in)     :: In

      type(student), pointer :: Elem
      integer ::  IO
      
      allocate (Elem)
      read (In, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) Elem%sur, Elem%init, Elem%date
      call Handle_IO_status(IO, "reading value from file")
      if (IO == 0) then
          Elem%next => ReadValue(In)
      else
         deallocate (Elem)
         nullify (Elem)
      end if
   end function ReadValue

   subroutine WriteGroup(output_file, Group, writeFilePostion, writeLetter)
      character(*), intent(in)           :: output_file, writeFilePostion, writeLetter
      type(student), pointer, intent(in) :: Group

      integer :: Out
      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write (out, '(/a)') writeLetter 
         call WriteGroup_val(Out, Group)
      close (Out)
   end subroutine WriteGroup
   ! вывод следующего значения
   recursive subroutine WriteGroup_val(Out, Elem)
      integer, intent(in)    :: Out
      type(student), pointer :: Elem
      
      integer  :: IO

      if (Associated(Elem)) then 
         write (Out, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) Elem%sur, Elem%init, Elem%date
         call Handle_IO_status(IO, "Некорректный вывод сотрудников")
         call WriteGroup_val(Out, Elem%next)
      end if
   end subroutine WriteGroup_val 

   subroutine WriteElement(output_file, stud, writeFilePostion, writeLetter)
      character(*), intent(in)  :: output_file, writeFilePostion, writeLetter
      type(student), intent(in) :: stud
      
      integer :: IO, Out

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write(Out, '(a)') writeLetter
         write(Out, '(a, 1x, a, 1x, i'//DATE_LEN//')', iostat=IO) stud%sur, stud%init, stud%date 
      close (Out)

   end subroutine WriteElement

end module IOGroup
