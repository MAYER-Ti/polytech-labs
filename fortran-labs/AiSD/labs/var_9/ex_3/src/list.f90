module mod_list
   use Environment

   implicit none
   private

   type, public :: node
      character(:, kind=CH_), allocatable :: string
      type(node), allocatable :: next    
   end type node

   type, public :: list
      type(node), allocatable :: head
      contains
          procedure, public         :: ReadList
          procedure, public         :: WriteList
          procedure, public, nopass :: InsertionSort
          final                     :: Delete
   end type

contains

   recursive subroutine InsertionSort(List, lastSorted)
      type(node), allocatable, intent(inout) :: List 
      type(node), allocatable, intent(inout) :: lastSorted
      type(node), allocatable :: tmp

      if(Allocated(lastSorted%next)) then 
         if(lastSorted%next%string < lastSorted%string) then
            ! Вырезать из списка элемент
            call move_alloc(lastSorted%next, tmp)
            call move_alloc(tmp%next, lastSorted%next)
            ! Вставить в нужное место
            call Paste(List, tmp)
            call InsertionSort(List, lastSorted)
         else 
            call InsertionSort(List, lastSorted%next)
         end if
      end if

   end subroutine InsertionSort

   pure recursive subroutine Paste(current, nodeToInsert)
      type(node), allocatable, intent(inout) :: current, nodeToInsert

      if(nodeToInsert%string < current%string) then
         call move_alloc(current, nodeToInsert%next)
         call move_alloc(nodeToInsert, current) 
      else 
         call Paste(current%next, nodeToInsert)
      end if

   end subroutine Paste

   pure subroutine Delete(dList)

      type(list), intent(inout) :: dList
      deallocate(dList%head)
   end subroutine Delete

   subroutine ReadList(dList, inputFile)
      character(*), intent(in) :: inputFile
      class(list)              :: dList

      integer :: In

      open (file=inputFile, encoding=E_, newunit=In)
        call ReadValue(In, dList%head)
      close (In)
   end subroutine ReadList

   recursive subroutine ReadValue(In, current)
      type(node), allocatable, target :: current
      integer, intent(in)             :: In

      integer, parameter      :: max_len = 1024
      character(max_len, CH_) :: string
      integer                 :: IO
      
      read(In, "(a)", iostat=IO) string
      call Handle_IO_status(IO, "reading value from file")
      if (IO == 0) then
          allocate(current)
          current%string = Trim(string)
         call ReadValue(In, current%next)
      end if
   end subroutine ReadValue
  
   subroutine WriteList(dList, outputFile, writeLetter, writePosition)
      character(*), intent(in) :: outputFile, writeLetter, writePosition
      class(list)              :: dList

      integer  :: Out
      
      open (file=outputFile, encoding=E_, position=writePosition, newunit=Out)
         write (out, '(/a)') writeLetter
         call WriteValue(Out, dList%head)
      close (Out)
   end subroutine WriteList

   recursive subroutine WriteValue(Out, Elem)
      integer, intent(in)     :: Out
      type(node), allocatable :: Elem
      
      integer  :: IO

      if (Allocated(Elem)) then 
         write (Out, '(a)', iostat=IO) Elem%string 
         call Handle_IO_status(IO, "writing list")
         call WriteValue(Out, Elem%next)
      end if
   end subroutine WriteValue 
   
end module mod_list 
