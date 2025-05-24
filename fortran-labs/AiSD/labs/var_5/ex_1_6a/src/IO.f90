module IOEmployee 
   use Environment
   implicit none

   integer, parameter :: BLOCK_LEN = 15

   type nodeEmpl 
       character(BLOCK_LEN, kind=CH_) :: sur = ""
       character(BLOCK_LEN, kind=CH_) :: pos = ""
       type(nodeEmpl), pointer :: next => Null()
   end type nodeEmpl 
   
   type nodePosCount 
       character(BLOCK_LEN, kind=CH_) :: pos = ""
       integer                        :: counts = 0
       type(nodePosCount), pointer    :: next => Null()
   end type nodePosCount

   interface WriteList 
      module procedure WriteList_Empl, WriteList_Pos 
   end interface  

 contains
   ! Чтение списка
   function ReadList(input_file) result(List) 
      character(*), intent(in) :: input_file 
      type(nodeEmpl), pointer  :: List 
      
      integer :: In
      
      open (file=Input_File, encoding=E_, newunit=In)
        List => ReadValue(In)
      close (In)
   end function ReadList
   ! Чтение следующего значения.
   recursive function ReadValue(In) result(Elem)
      integer, intent(in)     :: In

      type(nodeEmpl), pointer :: Elem
      integer ::  IO
      
      allocate (Elem)
      read (In, '(a, 1x, a)', iostat=IO) Elem%sur, Elem%pos
      call Handle_IO_status(IO, "reading value from file")
      if (IO == 0) then
          Elem%next => ReadValue(In)
      else
         deallocate (Elem)
         nullify (Elem)
      end if
   end function ReadValue
   ! Вывод списка сотрудников
   subroutine WriteList_Empl(output_file, List, writeFilePostion, writeLetter)
      character(*), intent(in)            :: output_file, writeFilePostion, writeLetter
      type(nodeEmpl), pointer, intent(in) :: List  

      integer :: Out

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write (out, '(/a)') writeLetter 
         call WriteValue_Empl(Out, List)
      close (Out)
   end subroutine WriteList_Empl
   ! вывод следующего значения
   recursive subroutine WriteValue_Empl(Out, Elem)
      integer, intent(in)     :: Out
      type(nodeEmpl), pointer :: Elem
      
      integer  :: IO

      if (Associated(Elem)) then 
         write (Out, '(a, 1x, a)', iostat=IO) Elem%sur, Elem%pos
         call Handle_IO_status(IO, "Некорректный вывод сотрудников")
         call WriteValue_Empl(Out, Elem%next)
      end if
   end subroutine WriteValue_Empl 
   ! Вывод списка должностей
   subroutine WriteList_Pos(output_file, List, writeFilePostion, writeLetter)
      character(*), intent(in)                :: output_file, writeFilePostion, writeLetter
      type(nodePosCount), pointer, intent(in) :: List  

      integer :: Out

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
         write (out, '(/a)') writeLetter 
         call WriteValue_Pos(Out, List)
      close (Out)
   end subroutine WriteList_Pos
   ! вывод следующего значения
   recursive subroutine WriteValue_Pos(Out, Elem)
      integer, intent(in)         :: Out
      type(nodePosCount), pointer :: Elem
      
      integer  :: IO

      if (Associated(Elem)) then 
         write (Out, '(a, 1x, i7)', iostat=IO) Elem%pos, Elem%counts
         call Handle_IO_status(IO, "Некорректный вывод количества должностей")
         call WriteValue_Pos(Out, Elem%next)
      end if
   end subroutine WriteValue_Pos 
end module IOEmployee 
