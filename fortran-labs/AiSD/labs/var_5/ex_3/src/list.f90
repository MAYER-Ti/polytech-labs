module mod_list
   use Environment

   implicit none
   private

   type, public :: node
      character(:, kind=CH_), allocatable :: string
      type(node), allocatable :: next    
      type(node), pointer     :: next_len => Null()
   end type node

   type, public :: list
      type(node), allocatable :: head
      type(node), pointer     :: sorted => Null()
      contains
          procedure, public :: ReadSortedList
          procedure, public :: WriteOrderedList
          procedure, public :: WriteUnorderedList
          procedure, public :: Sort
          final             :: Delete
   end type

contains
   pure recursive subroutine Sort(dList, current, HeadSort)
      class(list), intent(in) :: dList
      type(node), allocatable, intent(inout) :: current
      type(node), pointer, intent(inout)     :: HeadSort

      if(Allocated(current)) then 

         call SortStep(HeadSort, current)

         call dList%Sort(current%next, HeadSort)
      end if

   end subroutine Sort

   pure recursive subroutine SortStep(curSorted, nodeToInsert)
      type(node), allocatable, target, intent(inout) :: nodeToInsert
      type(node), pointer, intent(inout)             :: curSorted

      if (.not. Associated(curSorted)) then
         ! Либо голова пока никуда не ссылается,
         ! либо дошли до поледнего элемента.
         curSorted => nodeToInsert
      else if (LEN(nodeToInsert%string) >= LEN(curSorted%string)) then
         call SortStep(curSorted%next_len, nodeToInsert)
      else
         nodeToInsert%next_len => curSorted
         curSorted => nodeToInsert
      end if
   end subroutine SortStep

   pure subroutine Delete(dList)
      type(list), intent(inout) :: dList
      deallocate(dList%head)
      Nullify(dList%sorted)
   end subroutine Delete

   subroutine ReadSortedList(dList, inputFile)
      character(*), intent(in) :: inputFile
      class(list)              :: dList

      integer :: In

      open (file=inputFile, encoding=E_, newunit=In)
        call ReadSortedValue(In, dList%head)
      close (In)
   end subroutine ReadSortedList

   recursive subroutine ReadSortedValue(In, current)
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
         call ReadSortedValue(In, current%next)
      end if
   end subroutine ReadSortedValue
  
   subroutine WriteUnorderedList(dList, outputFile, writeLetter, writePosition)
      character(*), intent(in) :: outputFile, writeLetter, writePosition
      class(list)              :: dList

      integer  :: Out
      
      open (file=outputFile, encoding=E_, position=writePosition, newunit=Out)
         write (out, '(/a)') writeLetter
         call WriteUnorderedValue(Out, dList%head)
      close (Out)
   end subroutine WriteUnorderedList

   recursive subroutine WriteUnorderedValue(Out, Elem)
      integer, intent(in)     :: Out
      type(node), allocatable :: Elem
      
      integer  :: IO

      if (Allocated(Elem)) then 
         write (Out, '(a)', iostat=IO) Elem%string 
         call Handle_IO_status(IO, "writing list")
         call WriteUnorderedValue(Out, Elem%next)
      end if
   end subroutine WriteUnorderedValue 
   
   subroutine WriteOrderedList(dList, outputFile, writeLetter, writePosition)
      character(*), intent(in) :: outputFile, writeLetter, writePosition
      class(list) :: dList

      integer  :: Out
      
      open (file=outputFile, encoding=E_, position=writePosition, newunit=Out)
         write (out, '(/a)') writeLetter
         call WriteOrderedValue(Out, dList%sorted)
      close (Out)
   end subroutine WriteOrderedList  

   recursive subroutine WriteOrderedValue(Out, Elem)
      integer, intent(in) :: Out
      type(node), pointer :: Elem
      
      integer  :: IO

      if (Associated(Elem)) then 
         write (Out, '(a)', iostat=IO) Elem%string 
         call Handle_IO_status(IO, "writing list")
         call WriteOrderedValue(Out, Elem%next_len)
      end if
   end subroutine WriteOrderedValue 
end module mod_list 
